//
//  RenderTarget.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import UIKit
import Foundation
import Metal
import simd

class RenderTarget {

    private(set) var texture: MTLTexture?

    var scale: CGFloat = 1 {
        didSet {
            updateTransformBuffer()
        }
    }

    var zoom: CGFloat = 1

    var contentOffset: CGPoint = .zero {
        didSet {
            updateTransformBuffer()
        }
    }

    init(size: CGSize, pixelFormat: MTLPixelFormat, device: MTLDevice?) {
        
        self.drawableSize = size
        self.pixelFormat = pixelFormat
        self.device = device
        self.texture = makeEmptyTexture()
        self.commandQueue = device?.makeCommandQueue()
        
        renderPassDescriptor = MTLRenderPassDescriptor()
        let attachment = renderPassDescriptor?.colorAttachments[0]
        attachment?.texture = texture
        attachment?.loadAction = .load
        attachment?.storeAction = .store
        
        updateBuffer(with: size)
    }

    func clear() {
        texture = makeEmptyTexture()
        renderPassDescriptor?.colorAttachments[0].texture = texture
        commitCommands()
    }
    
    internal var pixelFormat: MTLPixelFormat = .bgra8Unorm
    internal var drawableSize: CGSize
    internal var uniform_buffer: MTLBuffer!
    internal var transform_buffer: MTLBuffer!
    internal var renderPassDescriptor: MTLRenderPassDescriptor?
    internal var commandBuffer: MTLCommandBuffer?
    internal var commandQueue: MTLCommandQueue?
    internal var device: MTLDevice?
    
    internal func updateBuffer(with size: CGSize) {
        self.drawableSize = size
        let metrix = Matrix.identity
        let zoomUniform = 2 * Float(zoom / scale )
        metrix.scaling(x: zoomUniform  / Float(size.width), y: -zoomUniform / Float(size.height), z: 1)
        metrix.translation(x: -1, y: 1, z: 0)
        uniform_buffer = device?.makeBuffer(bytes: metrix.m, length: MemoryLayout<Float>.size * 16, options: [])
        
        updateTransformBuffer()
    }
    
    internal func updateTransformBuffer() {
        let scaleFactor = UIScreen.main.nativeScale
        var transform = ScrollingTransform(offset: contentOffset * scaleFactor, scale: scale)
        transform_buffer = device?.makeBuffer(bytes: &transform, length: MemoryLayout<ScrollingTransform>.stride, options: [])
    }
    
    internal func prepareForDraw() {
        if commandBuffer == nil {
            commandBuffer = commandQueue?.makeCommandBuffer()
        }
    }

    internal func makeCommandEncoder() -> MTLRenderCommandEncoder? {
        guard let commandBuffer = commandBuffer, let rpd = renderPassDescriptor else {
            return nil
        }
        return commandBuffer.makeRenderCommandEncoder(descriptor: rpd)
    }
    
    internal func commitCommands() {
        commandBuffer?.commit()
        commandBuffer = nil
    }
    
    internal func makeEmptyTexture() -> MTLTexture? {
        guard drawableSize.width * drawableSize.height > 0 else {
            return nil
        }
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: pixelFormat,
                                                                         width: Int(drawableSize.width),
                                                                         height: Int(drawableSize.height),
                                                                         mipmapped: false)
        textureDescriptor.usage = [.renderTarget, .shaderRead]
        let texture = device?.makeTexture(descriptor: textureDescriptor)
        texture?.clear()
        return texture
    }
    
}
