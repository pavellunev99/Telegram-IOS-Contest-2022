//
//  Brush.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 13.10.2022.
//

import Foundation
import MetalKit
import UIKit

struct Pan {
    
    var point: CGPoint
    var force: CGFloat

    init(touch: UITouch, on view: UIView) {
        if #available(iOS 9.1, *) {
            point = touch.preciseLocation(in: view)
        } else {
            point = touch.location(in: view)
        }
        force = touch.force

        if touch.type == .direct, force == 0 {
            force = 1
        }
    }
    
    init(point: CGPoint, force: CGFloat) {
        self.point = point
        self.force = force
    }
}

class Brush {

    var name: String

    private(set) var textureID: String?

    weak var target: Canvas?

    var opacity: CGFloat = 0.3 {
        didSet {
            updateRenderingColor()
        }
    }

    var pointSize: CGFloat = 4
    var pointStep: CGFloat = 1
    var forceSensitive: CGFloat = 0
    var scaleWithCanvas = false
    var forceOnTap: CGFloat = 1

    var color: UIColor = .black {
        didSet {
            updateRenderingColor()
        }
    }

    enum Rotation {
        case fixed(CGFloat)
        case random
        case ahead
    }

    var rotation = Rotation.fixed(0)

    internal var renderingColor: MLColor = MLColor(red: 0, green: 0, blue: 0, alpha: 1)

    private func updateRenderingColor() {
        renderingColor = color.toMLColor(opacity: opacity)
    }

    required init(name: String?, textureID: String?, target: Canvas) {
        self.name = name ?? UUID().uuidString
        self.target = target
        self.textureID = textureID
        if let id = textureID {
            texture = target.findTexture(by: id)?.texture
        }
        updatePointPipeline()
    }

    func use() {
        target?.currentBrush = self
    }

    func makeLine(from: Pan, to: Pan) -> [MLLine] {
        let endForce = from.force * 0.95 + to.force * 0.05
        let forceRate = pow(endForce, forceSensitive)
        return makeLine(from: from.point, to: to.point, force: forceRate)
    }

    func makeLine(from: CGPoint, to: CGPoint, force: CGFloat? = nil, uniqueColor: Bool = false) -> [MLLine] {
        let force = force ?? forceOnTap
        let scale = scaleWithCanvas ? 1 : canvasScale
        let line = MLLine(begin: (from + canvasOffset) / canvasScale,
                          end: (to + canvasOffset) / canvasScale,
                          pointSize: pointSize * force / scale,
                          pointStep: pointStep / scale,
                          color: uniqueColor ? renderingColor : nil)
        return [line]
    }

    func finishLineStrip(at end: Pan) -> [MLLine] {
        return []
    }

    private var canvasScale: CGFloat {
        return target?.screenTarget?.scale ?? 1
    }
    
    private var canvasOffset: CGPoint {
        return target?.screenTarget?.contentOffset ?? .zero
    }

    private(set) weak var texture: MTLTexture?

    private(set) var pipelineState: MTLRenderPipelineState!

    func makeShaderLibrary(from device: MTLDevice) -> MTLLibrary? {
        return device.libraryMetallib()
    }

    func makeShaderVertexFunction(from library: MTLLibrary) -> MTLFunction? {
        return library.makeFunction(name: "vertex_point_func")
    }

    func makeShaderFragmentFunction(from library: MTLLibrary) -> MTLFunction? {
        if texture == nil {
            return library.makeFunction(name: "fragment_point_func_without_texture")
        }
        return library.makeFunction(name: "fragment_point_func")
    }

    func setupBlendOptions(for attachment: MTLRenderPipelineColorAttachmentDescriptor) {
        attachment.isBlendingEnabled = true

        attachment.rgbBlendOperation = .add
        attachment.sourceRGBBlendFactor = .sourceAlpha
        attachment.destinationRGBBlendFactor = .oneMinusSourceAlpha
        
        attachment.alphaBlendOperation = .add
        attachment.sourceAlphaBlendFactor = .one
        attachment.destinationAlphaBlendFactor = .oneMinusSourceAlpha
    }


    private func updatePointPipeline() {
        
        guard let target = target, let device = target.device, let library = makeShaderLibrary(from: device) else {
            return
        }
        
        let rpd = MTLRenderPipelineDescriptor()
        
        if let vertex_func = makeShaderVertexFunction(from: library) {
            rpd.vertexFunction = vertex_func
        }
        if let fragment_func = makeShaderFragmentFunction(from: library) {
            rpd.fragmentFunction = fragment_func
        }
        
        rpd.colorAttachments[0].pixelFormat = target.colorPixelFormat
        setupBlendOptions(for: rpd.colorAttachments[0]!)
        pipelineState = try! device.makeRenderPipelineState(descriptor: rpd)
    }

    internal func render(lineStrip: LineStrip, on renderTarget: RenderTarget? = nil) {
        
        let renderTarget = renderTarget ?? target?.screenTarget
        
        guard lineStrip.lines.count > 0, let target = renderTarget else {
            return
        }

        target.prepareForDraw()

        let commandEncoder = target.makeCommandEncoder()
        
        commandEncoder?.setRenderPipelineState(pipelineState)
        
        if let vertex_buffer = lineStrip.retrieveBuffers(rotation: rotation) {
            commandEncoder?.setVertexBuffer(vertex_buffer, offset: 0, index: 0)
            commandEncoder?.setVertexBuffer(target.uniform_buffer, offset: 0, index: 1)
            commandEncoder?.setVertexBuffer(target.transform_buffer, offset: 0, index: 2)
            if let texture = texture {
                commandEncoder?.setFragmentTexture(texture, index: 0)
            }
            commandEncoder?.drawPrimitives(type: .point, vertexStart: 0, vertexCount: lineStrip.vertexCount)
        }
        
        commandEncoder?.endEncoding()
    }

    private var bezierGenerator = BezierGenerator()

    private var lastRenderedPan: Pan?
    
    private func pushPoint(_ point: CGPoint, to bezier: BezierGenerator, force: CGFloat, isEnd: Bool = false, on canvas: Canvas) {
        var lines: [MLLine] = []
        let vertices = bezier.pushPoint(point)
        guard vertices.count >= 2 else {
            return
        }
        var lastPan = lastRenderedPan ?? Pan(point: vertices[0], force: force)
        let deltaForce = (force - (lastRenderedPan?.force ?? force)) / CGFloat(vertices.count)
        for i in 1 ..< vertices.count {
            let p = vertices[i]
            if  // end point of line
                (isEnd && i == vertices.count - 1) ||
                    // ignore step
                    pointStep <= 1 ||
                    // distance larger than step
                    (pointStep > 1 && lastPan.point.distance(to: p) >= pointStep)
            {
                let force = lastPan.force + deltaForce
                let pan = Pan(point: p, force: force)
                let line = makeLine(from: lastPan, to: pan)
                lines.append(contentsOf: line)
                lastPan = pan
                lastRenderedPan = pan
            }
        }
        render(lines: lines, on: canvas)
    }
    
    func render(lines: [MLLine], on canvas: Canvas) {
        canvas.render(lines: lines)
    }

    func renderBegan(from pan: Pan, on canvas: Canvas) -> Bool {
        lastRenderedPan = pan
        bezierGenerator.begin(with: pan.point)
        pushPoint(pan.point, to: bezierGenerator, force: pan.force, on: canvas)
        return true
    }

    func renderMoved(to pan: Pan, on canvas: Canvas) -> Bool {
        guard bezierGenerator.points.count > 0 else { return false }
        guard pan.point != lastRenderedPan?.point else {
            return false
        }
        pushPoint(pan.point, to: bezierGenerator, force: pan.force, on: canvas)
        return true
    }

    func renderEnded(at pan: Pan, on canvas: Canvas) {
        defer {
            bezierGenerator.finish()
            lastRenderedPan = nil
        }
        
        let count = bezierGenerator.points.count
        if count >= 3 {
            pushPoint(pan.point, to: bezierGenerator, force: pan.force, isEnd: true, on: canvas)
        } else if count > 0 {
            canvas.renderTap(at: bezierGenerator.points.first!, to: bezierGenerator.points.last!)
        }
        
        let unfishedLines = finishLineStrip(at: Pan(point: pan.point, force: pan.force))
        if unfishedLines.count > 0 {
            canvas.render(lines: unfishedLines)
        }
    }
}
