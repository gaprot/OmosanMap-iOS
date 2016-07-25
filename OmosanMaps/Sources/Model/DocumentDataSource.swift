//
//  DocumentDataSource.swift
//  OmosanMaps
//
//  Created by Gaprot Dev Team on 2016/02/16.
//  Copyright © 2016年 Up-frontier, Inc. All rights reserved.
//

import Foundation
import Alamofire
import SSZipArchive
import Ji

class DocumentDataSource
{
    enum Error: ErrorType {
        case DownloadFailed
        case KMLParseFailed
    }
    
    static let shared: DocumentDataSource = DocumentDataSource()
    
    private var basePath: String?
    private(set) var document: Document?
    
    var hasDocument: Bool {
        return self.document != nil
    }
    
    func fetch(URLString: String, handler: (error: ErrorType?) -> Void) {
        if self.hasDocument {
            handler(error: nil)
            return
        }
        
        let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)[0]
        var localURL: NSURL?
        Alamofire
            .download(
                .GET,
                URLString,
                destination: { (temporaryURL, response) in
                    // ファイルのダウンロード先を指定
                    guard let pathComponent = response.suggestedFilename else {
                        fatalError()
                    }
                    let destinationURL = directoryURL.URLByAppendingPathComponent(pathComponent)

                    // 同名のファイルが残っている場合は削除しておく
                    if
                        let destinationPath = destinationURL.path
                    where
                        NSFileManager.defaultManager().fileExistsAtPath(destinationPath)
                    {
                        try! NSFileManager.defaultManager().removeItemAtPath(destinationPath)
                    }
                    
                    localURL = destinationURL
                    return destinationURL
            }).response{ (request, response, data, error) in
                var result: ErrorType?
                defer {
                    handler(error: result)
                }
                
                if let error = error {
                    result = error
                } else {
                    guard let localPath = localURL?.path else {
                        fatalError()
                    }
                    
                    let kmlDirPath = localPath.stringByReplacingOccurrencesOfString(".kmz", withString: "")
                    self.basePath = kmlDirPath
                    
                    if NSFileManager.defaultManager().fileExistsAtPath(kmlDirPath) {
                        try! NSFileManager.defaultManager().removeItemAtPath(kmlDirPath)
                    }

                    // KMZファイルを展開
                    if SSZipArchive.unzipFileAtPath(localPath, toDestination: kmlDirPath) {
                        let kmlPath = kmlDirPath.stringByAppendingString("/doc.kml")
                        do {
                            try self.parseKML(kmlPath)
                        } catch let error {
                            result = error
                        }
                        if let kml = try? String(contentsOfFile: kmlPath, encoding: NSUTF8StringEncoding) {
                            print(kml)
                        }
                    } else {
                        // URLが間違っているとここに来ることがある
                        result = Error.DownloadFailed
                    }
                }
        }
    
    }
    
    func clear() {
        self.document = nil
    }
    
// MARK: - parse KML
    
    private func parseKML(path: String) throws {
        guard
            let doc = Ji(xmlURL: NSURL(fileURLWithPath: path)),
            let kmlNode = doc.rootNode
        else {
            throw Error.KMLParseFailed
        }

        for childNode in kmlNode.children {
            guard let childNodeName = childNode.name?.lowercaseString else {
                continue
            }
            
            switch childNodeName {
            case "document":
                self.document = Document.fromJiNode(childNode)
            default:
                break
            }
        }
    }
}

extension DocumentDataSource {
    func iconColor(for styleID: String) -> UIColor? {
        guard let style = self.document?.styles[styleID] else {
            return nil
        }

        return style.color
    }
    
    func iconURL(for styleID: String) -> NSURL? {
        guard let style = self.document?.styles[styleID] else {
            return nil
        }

        if
            let urlComponents = NSURLComponents(string: style.iconRef)
        where
            urlComponents.scheme == "http" || urlComponents.scheme == "https"
        {
            return NSURL(string: style.iconRef)!
        }
        
        guard let basePath = self.basePath else {
            return nil
        }
        let baseURL = NSURL(fileURLWithPath: basePath)
        return baseURL.URLByAppendingPathComponent(style.iconRef)
    }
}

import CoreLocation
extension DocumentDataSource {
    class Filter {
        enum Region: Int {
            case Unlimited
            case Neighbor
            case Near
            
            var description: String {
                switch self {
                case .Unlimited:
                    return "すべて"
                case .Neighbor:
                    return "5分以内"
                case .Near:
                    return "10分以内"
                }
            }
            
            var distance: CLLocationDistance? {
                switch self {
                case .Unlimited:
                    return nil
                case .Neighbor:
                    return 5.0 * 60
                case .Near:
                    return 10.0 * 60
                }
            }
        }
        
        var folderNames: [String]?
        var baseLocation: CLLocation?
        //var distance: CLLocationDistance?
        var region: Region?
        
        func addFolderName(name: String) {
            if self.folderNames == nil {
                self.folderNames = [name]
            } else {
                self.folderNames?.append(name)
            }
        }
        
        func removeFolderName(name: String) {
            if let index = self.folderNames?.indexOf(name) {
                self.folderNames?.removeAtIndex(index)
            }
            if self.folderNames?.isEmpty ?? false {
                self.folderNames = nil
            }
        }
        
        func hasFolderName(name: String) -> Bool {
            if let folderNames = self.folderNames {
                return folderNames.contains(name)
            } else {
                return false
            }
        }
    }
    
    func placemarksForFilter(filter: Filter) -> [Placemark] {
        guard let document = self.document else {
            return []
        }
        
        let folders: [Folder]
        if let folderNames = filter.folderNames {
            folders = document.foldersForNames(folderNames)
        } else {
            folders = document.folders
        }

        var placemarks = [Placemark]()
        if let baseLocation = filter.baseLocation, let distance = filter.region?.distance {
            for folder in folders {
                placemarks += folder.placemarksInRange(baseLocation: baseLocation, distance: distance)
            }
        } else {
            for folder in folders {
                placemarks += folder.placemarks
            }
        }
        
        return placemarks
    }
    
    func placemarksForCoordinate(coordinate: CLLocationCoordinate2D) -> [Placemark] {
        guard let document = self.document else {
            return []
        }

        var placemarks = [Placemark]()
        for folder in document.folders {
            placemarks += folder.placemarks.filter{ (placemark) -> Bool in
                return placemark.coordinate.latitude == coordinate.latitude && placemark.coordinate.longitude == coordinate.longitude
            }
        }
        
        return placemarks
    }
}
