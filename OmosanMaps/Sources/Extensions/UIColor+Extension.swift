//
//  UIColor+Extension.swift
//  OmosanMaps
//
//  Created by Gaprot Dev Team on 2016/07/13.
//  Copyright © 2016年 Up-frontier, Inc. All rights reserved.
//

import UIKit

extension UIColor {
    /**
     KMLの16進カラーコードで初期化.
     
     - parameter kmlHexCode: KMLの16進カラーコード(ABGR)
     */
    convenience init?(kmlHexCode: String) {
        let scanner = NSScanner(string: kmlHexCode)
        
        var value: UInt32 = 0
        if (!scanner.scanHexInt(&value)) {
            return nil
        }

        let max = CGFloat(255.0)
        let a = CGFloat((value >> 24) & 0xff) / max
        let b = CGFloat((value >> 16) & 0xff) / max
        let g = CGFloat((value >>  8) & 0xff) / max
        let r = CGFloat((value      ) & 0xff) / max
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
