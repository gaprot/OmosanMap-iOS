//
//  UIImage+Extension.swift
//  OmosanMaps
//
//  Created by Gaprot Dev Team on 2016/07/13.
//  Copyright © 2016年 Up-frontier, Inc. All rights reserved.
//

import UIKit

extension UIImage {
    /**
     カラーフィルタを適用した画像を生成.
     
     - parameter color: カラー.
     
     - returns: 画像を返す.
     */
    func filteringColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard
            let context = UIGraphicsGetCurrentContext(),
            let cgImage = self.CGImage
        else {
            fatalError()
        }
        let rect = CGRect(origin: CGPointZero, size: self.size)

        // 上下反転
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)

        CGContextSetBlendMode(context, .Normal)
        //self.drawInRect(rect)
        CGContextDrawImage(context, rect, cgImage)
        
        CGContextClipToMask(context, rect, cgImage)
        CGContextSetBlendMode(context, .Multiply)
        color.setFill()
        CGContextFillRect(context, rect)

        guard let filteredImage = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError()
        }
        return filteredImage
    }
}
