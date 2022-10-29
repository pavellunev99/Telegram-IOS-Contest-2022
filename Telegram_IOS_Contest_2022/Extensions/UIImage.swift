//
//  UIImage.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 23.10.2022.
//

import UIKit

extension UIImage {

    func compositeWith(image: UIImage) -> UIImage? {

        guard let cgImage = self.cgImage else { return nil }

        let bounds1 = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let bounds2 = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

        let ctx = CGContext(data: nil,
                            width: cgImage.width,
                            height: cgImage.height,
                            bitsPerComponent: cgImage.bitsPerComponent,
                            bytesPerRow: cgImage.bytesPerRow,
                            space: cgImage.colorSpace!,
                            bitmapInfo: bitmapInfo.rawValue)!


        ctx.draw(cgImage, in: bounds1, byTiling: false)
        //CGContextDrawImage(ctx, bounds1, cgImage)
        ctx.setBlendMode(.normal)
        //CGContextDrawImage(ctx, bounds2, image.cgImage)
        ctx.draw(image.cgImage!, in: bounds2, byTiling: false)

        if let bitmapImage = ctx.makeImage() {
            return UIImage(cgImage: bitmapImage)
        } else {
            return nil
        }
    }
}

extension UIImage {

    static func imageWithPixelSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, opaque: Bool = false) -> UIImage? {
        return imageWithSize(size: size, filledWithColor: color, scale: 1.0, opaque: opaque)
    }

    static func imageWithSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, scale: CGFloat = 0.0, opaque: Bool = false) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        color.set()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
