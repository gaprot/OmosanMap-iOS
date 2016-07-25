//
//  Placemark.swift
//  OmosanMaps
//
//  Created by Gaprot Dev Team on 2016/02/16.
//  Copyright © 2016年 Up-frontier, Inc. All rights reserved.
//

import Foundation
import CoreLocation
import Ji

/**
 *  地点情報。
 */
struct Placemark
{
    let name: String
    let descriptionText: String
    let coordinate: CLLocationCoordinate2D
    let imageURLs: [NSURL]
    let styleID: String
}

extension Placemark {
    var sanitizedDescriptionText: String {
        return self.descriptionText.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
    }
}

extension Placemark
{
    /**
     XML ノードから地点情報を求める。
     
     - parameter node: Placemark ノード。
     
     - returns: 地点情報を返す。
     */
    static func fromJiNode(node: JiNode) -> Placemark {
        var name = ""
        var descriptionText = ""
        var coordinate = CLLocationCoordinate2D()
        var imageURLs = [NSURL]()
        var styleID = ""
        for childNode in node.children {
            guard let childNodeName = childNode.name?.lowercaseString else {
                continue
            }
            
            switch (childNodeName) {
            case "name":
                name = childNode.content ?? ""
            case "description":
                descriptionText = childNode.content ?? ""
            case "point":
                coordinate = CLLocationCoordinate2D.fromJiNode(childNode)
            case "extendeddata":
                imageURLs = self.extractImageURLs(childNode)
            case "styleurl":
                if let content = childNode.content {
                    styleID = content.substringFromIndex(content.startIndex.successor())
                }
            default:
                break
            }
        }
        return Placemark(
            name: name,
            descriptionText: descriptionText,
            coordinate: coordinate,
            imageURLs: imageURLs,
            styleID: styleID
        )
    }
    
    /**
     画像 URL を抽出。
     
     - parameter extendedDataNode: ExtendedData ノード。
     
     - returns: 画像 URL の配列を返す。
     */
    static private func extractImageURLs(extendedDataNode: JiNode) -> [NSURL] {
        for childNode in extendedDataNode.children {
            guard let childNodeName = childNode.name?.lowercaseString else {
                continue
            }

            if let valueNode = childNode.firstChildWithName("value")
            where childNodeName == "data" && childNode["name"] == "gx_media_links" {
                let joinedImageURLString = valueNode.content ?? ""
                var imageURLs = [NSURL]()
                for imageURLString in joinedImageURLString.componentsSeparatedByString(" ") {
                    if let imageURL = NSURL(string: imageURLString) {
                        imageURLs.append(imageURL)
                    }
                }
                
                return imageURLs
            }
        }
        
        return []
    }
}

extension CLLocationCoordinate2D
{
    /**
     XML ノードから緯度経度を求める。
     
     - parameter node: Point ノード。
     
     - returns: 緯度経度を返す。
     */
    static func fromJiNode(node: JiNode) -> CLLocationCoordinate2D {
        var coordinate = CLLocationCoordinate2D()
        for childNode in node.children {
            guard let childNodeName = childNode.name?.lowercaseString else {
                continue
            }
            
            switch (childNodeName) {
            case "coordinates":
                guard let coordinates = childNode.content else {
                    break
                }
                let coordinateValues = coordinates.componentsSeparatedByString(",")
                
                if
                    let longitude = Double(coordinateValues[0]),
                    let latitude = Double(coordinateValues[1])
                {
                    coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
            default:
                break
            }
        }

        return coordinate
    }
}
