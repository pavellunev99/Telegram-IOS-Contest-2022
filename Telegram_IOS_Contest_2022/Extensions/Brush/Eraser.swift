//
//  Eraser.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import Foundation
import UIKit
import Metal

class Eraser: Brush {
    
    override func setupBlendOptions(for attachment: MTLRenderPipelineColorAttachmentDescriptor) {
        attachment.isBlendingEnabled = true
        attachment.alphaBlendOperation = .reverseSubtract
        attachment.rgbBlendOperation = .reverseSubtract
        attachment.sourceRGBBlendFactor = .zero
        attachment.sourceAlphaBlendFactor = .one
        attachment.destinationRGBBlendFactor = .oneMinusSourceAlpha
        attachment.destinationAlphaBlendFactor = .one
    }
}
