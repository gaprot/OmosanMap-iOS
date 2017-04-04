//
//  Style.swift
//  OmosanMaps
//
//  Created by Gaprot Dev Team on 2016/07/07.
//  Copyright © 2016年 Up-frontier, Inc. All rights reserved.
//

import Foundation
import Ji

/**
 *  マーカーのスタイル.
 */
struct Style {
    let id: String
    let color: UIColor?
    let iconRef: String
}

extension Style
{
    /**
     XML ノードからマーカースタイルを求める。
     
     - parameter node: Style ノード。
     
     - returns: マーカースタイルを返す。
     */
    static func fromJiNode(node: JiNode) -> Style {
        let id = node["id"] ?? ""
        
        guard let iconStyleNode = node.firstChildNoCase(with: "iconstyle") else {
            fatalError()
        }
        
        var color: UIColor?
        var iconRef = ""
        for childNode in iconStyleNode.children {
            guard let childNodeName = childNode.name?.lowercased() else {
                continue
            }
            
            switch (childNodeName) {
            case "color":
                color = UIColor(kmlHexCode: childNode.content ?? "")
            case "icon":
                if let hrefNode = childNode.firstChildNoCase(with: "href") {
                    iconRef = hrefNode.content ?? ""
                }
            default:
                break
            }
        }
        return Style(
            id: id,
            color: color,
            iconRef: iconRef
        )
    }
}
