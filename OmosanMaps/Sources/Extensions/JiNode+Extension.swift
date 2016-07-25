//
//  JiNode+Extension.swift
//  OmosanMaps
//
//  Created by Gaprot Dev Team on 2016/07/07.
//  Copyright © 2016年 Up-frontier, Inc. All rights reserved.
//

import Foundation
import Ji

extension JiNode {
    func firstChildNoCase(with name: String) -> JiNode? {
        for childNode in self.children {
            if childNode.name?.lowercaseString == name {
                return childNode
            }
        }
        
        return nil
    }
}
