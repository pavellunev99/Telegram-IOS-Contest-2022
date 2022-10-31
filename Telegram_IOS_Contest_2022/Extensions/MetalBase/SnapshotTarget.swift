//
//  SnapshotTarget.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import Foundation
import UIKit

class SnapshotTarget: RenderTarget {
    
    private weak var canvas: Canvas?

    init(canvas: Canvas) {
        self.canvas = canvas
        let size = canvas.bounds.size
        super.init(size: size, pixelFormat: canvas.colorPixelFormat, device: canvas.device)
    }

    func getImage() -> UIImage? {
        syncContent()
        return texture?.toUIImage()
    }

    func getCIImage() -> CIImage? {
        syncContent()
        return texture?.toCIImage()
    }

    func getCGImage() -> CGImage? {
        syncContent()
        return texture?.toCGImage()
    }

    func getImage(canvasElement: CanvasElement) -> UIImage? {
        syncContent(canvasElement: canvasElement)
        return texture?.toUIImage()
    }

    func getCIImage(canvasElement: CanvasElement) -> CIImage? {
        syncContent(canvasElement: canvasElement)
        return texture?.toCIImage()
    }

    func getCGImage(canvasElement: CanvasElement) -> CGImage? {
        syncContent(canvasElement: canvasElement)
        return texture?.toCGImage()
    }

    private func syncContent(canvasElement: CanvasElement? = nil) {
        if let canvasElement = canvasElement {
            let scale = canvas?.contentScaleFactor ?? 1
            updateBuffer(with: CGSize(width: drawableSize.width * scale, height: drawableSize.height * scale))
            prepareForDraw()
            clear()
            canvasElement.drawSelf(on: self)
        } else {
            canvas?.redraw(on: self)
        }
        commitCommands()
    }
}
