//
//  DocumentDataSource.swift
//  OmosanMaps
//
//  Created by yuichi.kobayashi on 2016/02/16.
//  Copyright © 2016年 *. All rights reserved.
//

import Foundation
import Alamofire
import SSZipArchive
import Ji

class DocumentDataSource
{
    private (set) var document: Document?
    
    func fetch(URLString: String, handler: (error: ErrorType?) -> Void) {
        let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        var localURL: NSURL?
        Alamofire
            .download(
                .GET,
                "https://www.google.com/maps/d/u/0/kml?mid=zmkzjAlquG4s.k9j-gW9GbmCQ",
                destination: { (temporaryURL, response) in
                    let pathComponent = response.suggestedFilename
                    
                    localURL = directoryURL.URLByAppendingPathComponent(pathComponent!)
                    return localURL!
            }).response{ (request, response, data, error) in
                if false {//let error = error {		// TODO: 通信成功しても、ファイル上書きエラーが来てしまう
                    handler(error: error)
                } else {
                    if let localPath = localURL?.path {
                        let kmlDirPath = localPath.stringByReplacingOccurrencesOfString(".kmz", withString: "")
                        if SSZipArchive.unzipFileAtPath(localPath, toDestination: kmlDirPath) {
                            let kmlPath = kmlDirPath.stringByAppendingString("/doc.kml")
                            self.parseKML(kmlPath)
                            handler(error: nil)
//                            if let kml = try? String(contentsOfFile: kmlPath, encoding: NSUTF8StringEncoding) {
//                                print(kml)
//                            }
                        }
                    }
                }
        }
        
    }
    
// MARK: - parse KML
    
    private func parseKML(path: String) {
        guard
            let doc = Ji(xmlURL: NSURL(fileURLWithPath: path)),
            let kmlNode = doc.rootNode
        else {
            return		// TODO: error
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
