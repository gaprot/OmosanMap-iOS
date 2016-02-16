//
//  Document.swift
//  OmosanMaps
//
//  Created by yuichi.kobayashi on 2016/02/16.
//  Copyright © 2016年 *. All rights reserved.
//

import Foundation
import Ji

struct Document
{
    let name: String
    let description: String
    let folders: [Folder]
}

extension Document
{
    static func fromJiNode(node: JiNode) -> Document {
        var name = ""
        var description = ""
        var folders: [Folder] = []
        for childNode in node.children {
            guard let childNodeName = childNode.name?.lowercaseString else {
                continue
            }
            
            switch (childNodeName) {
            case "name":
                name = childNode.content ?? ""
            case "description":
                description = childNode.content ?? ""
            case "folder":
                folders.append(Folder.fromJiNode(childNode))
            default:
                break
            }
        }
        
        return Document(name: name, description: description, folders: folders)
    }
}
