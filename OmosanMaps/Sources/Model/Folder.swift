//
//  Folder.swift
//  OmosanMaps
//
//  Created by yuichi.kobayashi on 2016/02/16.
//  Copyright © 2016年 *. All rights reserved.
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
            guard let childNodeName = childNode.name?.lowercaseString else {
                continue
            }
            
            switch (childNodeName) {
            case "name":
                name = childNode.content ?? ""
            case "placemark":
                placemarks.append(Placemark.fromJiNode(childNode))
            default:
                break
            }
        }
        
        return Folder(name: name, placemarks: placemarks)
    }
}
