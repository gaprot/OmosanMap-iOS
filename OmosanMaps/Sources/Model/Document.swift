//
//  Document.swift
//  OmosanMaps
//
//  Created by Gaprot Dev Team on 2016/02/16.
//  Copyright © 2016年 Up-frontier, Inc. All rights reserved.
//

import Foundation
import Ji

/**
 *  ドキュメント。
 */
struct Document
{
    
    let name: String
    let description: String
    let folders: [Folder]
    let styles: [String: Style]
}

extension Document
{
    /**
     XML ノードからドキュメントを求める。
     
     - parameter node: Document ノード。
     
     - returns: ドキュメントを返す。
     */
    static func fromJiNode(node: JiNode) -> Document {
        var name = ""
        var description = ""
        var folders: [Folder] = []
        var styles: [String: Style] = [:]
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
            case "style":
                let style = Style.fromJiNode(childNode)
                styles[style.id] = style
            default:
                break
            }
        }
        
        return Document(
            name: name,
            description: description,
            folders: folders,
            styles: styles
        )
    }
}

extension Document {
    func foldersForNames(names: [String]) -> [Folder] {
        return self.folders.filter { (folder) -> Bool in
            return names.contains(folder.name)
        }
    }
}
