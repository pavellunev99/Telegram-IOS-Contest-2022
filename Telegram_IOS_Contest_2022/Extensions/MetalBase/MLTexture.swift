//
//  MLTexture.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import Foundation
import Metal
import UIKit

class MLTexture: Hashable {
    
    private(set) var id: String
    
    private(set) var texture: MTLTexture
    
    init(id: String, texture: MTLTexture) {
        self.id = id
        self.texture = texture
    }

    lazy var size: CGSize = {
        let scaleFactor = UIScreen.main.nativeScale
        return CGSize(width: CGFloat(texture.width) / scaleFactor, height: CGFloat(texture.height) / scaleFactor)
    }()

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MLTexture, rhs: MLTexture) -> Bool {
        return lhs.id == rhs.id
    }
}

extension MTLTexture {

    func toCIImage() -> CIImage? {
        let image = CIImage(mtlTexture: self, options: [.colorSpace: CGColorSpaceCreateDeviceRGB()])
        return image?.oriented(forExifOrientation: 4)
    }

    func toCGImage() -> CGImage? {
        guard let ciimage = toCIImage() else {
            return nil
        }
        let context = CIContext()
        let rect = CGRect(origin: .zero, size: ciimage.extent.size)
        return context.createCGImage(ciimage, from: rect)
    }

    func toUIImage() -> UIImage? {
        guard let cgimage = toCGImage() else {
            return nil
        }
        return UIImage(cgImage: cgimage)
    }

    func toData() -> Data? {
        guard let image = toUIImage() else {
            return nil
        }
        return image.pngData()
    }
}
