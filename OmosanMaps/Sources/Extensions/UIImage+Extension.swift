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
            let cgImage = self.cgImage
        else {
            fatalError()
        }
        let rect = CGRect(origin: .zero, size: self.size)

        // 上下反転
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        context.setBlendMode(.normal)
        //self.drawInRect(rect)
        context.draw(cgImage, in: rect)

        context.clip(to: rect, mask: cgImage)
        context.setBlendMode(.multiply)
        color.setFill()
        context.fill(rect)

        guard let filteredImage = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError()
        }
        return filteredImage
    }
}
