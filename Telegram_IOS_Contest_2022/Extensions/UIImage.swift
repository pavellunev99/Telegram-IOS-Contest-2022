//
//  UIImage.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 23.10.2022.
//

import UIKit
import Photos

extension UIImage {

    func compositeWith(image: UIImage) -> UIImage? {

        guard let cgImage = self.cgImage else { return nil }

        let bounds1 = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let bounds2 = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

        guard let ctx = CGContext(data: nil,
                                  width: cgImage.width,
                                  height: cgImage.height,
                                  bitsPerComponent: cgImage.bitsPerComponent,
                                  bytesPerRow: cgImage.bytesPerRow,
                                  space: cgImage.colorSpace!,
                                  bitmapInfo: bitmapInfo.rawValue)
        else {
            print("image context is nil")
            return nil
        }

        ctx.draw(cgImage, in: bounds1, byTiling: false)
        ctx.setBlendMode(.normal)
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

extension UIImageView {

    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {

        let options = PHImageRequestOptions()
        options.version = .current

        PHImageManager.default().requestImage(for: asset,
                                              targetSize: targetSize,
                                              contentMode: contentMode,
                                              options: options) { image, _ in
            guard let image = image else { return }

            switch contentMode {
            case .aspectFill:
                self.contentMode = .scaleAspectFill
            case .aspectFit:
                self.contentMode = .scaleAspectFit
            @unknown default:
                self.contentMode = .scaleAspectFill
            }

            self.image = image
        }
    }
}
