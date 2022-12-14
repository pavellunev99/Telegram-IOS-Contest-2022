//
//  Chartlet.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import Foundation
import UIKit
import Metal

/// not implemented yet
class Chartlet: CanvasElement {
    
    var index: Int = 0
    
    var center: CGPoint
    
    var size: CGSize
    
    var textureID: String
    
    var angle: CGFloat?
    
    /// a weak refreance to canvas
    weak var canvas: Canvas?
    
    init(center: CGPoint, size: CGSize, textureID: String, angle: CGFloat, canvas: Canvas) {
        let offset = canvas.contentOffset
        let scale = canvas.scale
        self.canvas = canvas
        self.center = (center + offset) / scale
        self.size = size / scale
        self.textureID = textureID
        self.angle = angle
    }
    
    /// draw self with printer of canvas
    func drawSelf(on target: RenderTarget?) {
        canvas?.printer.render(chartlet: self, on: target)
    }
    
    lazy var vertex_buffer: MTLBuffer? = {
        let scale = canvas?.printer.target?.contentScaleFactor ?? UIScreen.main.nativeScale
        
        let center = self.center * scale
        let halfSize = self.size * scale * 0.5
        let angle = self.angle ?? 0
        let vertexes = [
            Vertex(position: CGPoint(x: center.x - halfSize.width, y: center.y - halfSize.height).rotatedBy(angle, anchor: center),
                   textCoord: CGPoint(x: 0, y: 0)),
            Vertex(position: CGPoint(x: center.x + halfSize.width , y: center.y - halfSize.height).rotatedBy(angle, anchor: center),
                   textCoord: CGPoint(x: 1, y: 0)),
            Vertex(position: CGPoint(x: center.x - halfSize.width , y: center.y + halfSize.height).rotatedBy(angle, anchor: center),
                   textCoord: CGPoint(x: 0, y: 1)),
            Vertex(position: CGPoint(x: center.x + halfSize.width , y: center.y + halfSize.height).rotatedBy(angle, anchor: center),
                   textCoord: CGPoint(x: 1, y: 1)),
        ]
        return sharedDevice?.makeBuffer(bytes: vertexes, length: MemoryLayout<Vertex>.stride * 4, options: .cpuCacheModeWriteCombined)
    }()
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case index
        case center
        case size
        case texture
        case angle
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        index = try container.decode(Int.self, forKey: .index)
        let centerInts = try container.decode([Int].self, forKey: .center)
        center = CGPoint.make(from: centerInts)
        let sizeInts = try container.decode([Int].self, forKey: .size)
        size = CGSize.make(from: sizeInts)
        textureID = try container.decode(String.self, forKey: .texture)
        angle = try? container.decode(CGFloat.self, forKey: .angle)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(index, forKey: .index)
        try container.encode(center.encodeToInts(), forKey: .center)
        try container.encode(size.encodeToInts(), forKey: .size)
        try container.encode(textureID, forKey: .texture)
        if let angle = self.angle {
            try container.encode(angle, forKey: .angle)
        }
    }
}
