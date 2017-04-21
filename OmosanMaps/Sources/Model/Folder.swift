//
//  Folder.swift
//  OmosanMaps
//
//  Created by Gaprot Dev Team on 2016/02/16.
//  Copyright © 2016年 Up-frontier, Inc. All rights reserved.
//

import Foundation
import Ji

/**
 *  フォルダ。
 */
struct Folder
{
    let name: String
    let placemarks: [Placemark]
}

extension Folder
{
    /**
     XML ノードからフォルダを求める。
     
     - parameter node: Folder ノード。
     
     - returns: フォルダを返す。
     */
    static func fromJiNode(node: JiNode) -> Folder {
        var name = ""
        var placemarks: [Placemark] = []
        for childNode in node.children {
            guard let childNodeName = childNode.name?.lowercased() else {
                continue
            }
            
            switch (childNodeName) {
            case "name":
                name = childNode.content ?? ""
            case "placemark":
                placemarks.append(Placemark.fromJiNode(node: childNode))
            default:
                break
            }
        }
        
        return Folder(name: name, placemarks: placemarks)
    }
}

import CoreLocation
extension Folder {
    func placemarksInRange(
        baseLocation: CLLocation,
        distance: CLLocationDistance
    ) -> [Placemark] {
        return self.placemarks.filter { (placemark) -> Bool in
            let location = CLLocation(
                latitude: placemark.coordinate.latitude,
                longitude: placemark.coordinate.longitude
            )
            
            return location.distance(from: baseLocation) <= distance
        }
    }
}
