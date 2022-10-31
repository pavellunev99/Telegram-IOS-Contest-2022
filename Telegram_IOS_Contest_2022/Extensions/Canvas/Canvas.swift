//
//  Canvas.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 13.10.2022.
//

import UIKit

class Canvas: MetalView {

    var defaultBrush: Brush!
    private(set) var printer: Printer!

    var isPencilMode = false {
        didSet {
            isMultipleTouchEnabled = isPencilMode
        }
    }
    
    var useFingersToErase = false

    var size: CGSize {
        return drawableSize / contentScaleFactor
    }
    
    weak var renderingDelegate: RenderingDelegate?
    
    internal var actionObservers = ActionObserverPool()

    func addObserver(_ observer: ActionObserver) {
        actionObservers.clean()
        actionObservers.addObserver(observer)
    }

    @discardableResult func registerBrush<T: Brush>(name: String? = nil, from data: Data) throws -> T {
        let texture = try makeTexture(with: data)
        let brush = T(name: name, textureID: texture.id, target: self)
        registeredBrushes.append(brush)
        return brush
    }

    @discardableResult func registerBrush<T: Brush>(name: String? = nil, from file: URL) throws -> T {
        let data = try Data(contentsOf: file)
        return try registerBrush(name: name, from: data)
    }

    func registerBrush<T: Brush>(name: String? = nil, textureID: String? = nil) throws -> T {
        let brush = T(name: name, textureID: textureID, target: self)
        registeredBrushes.append(brush)
        return brush
    }

    func register<T: Brush>(brush: T) {
        brush.target = self
        registeredBrushes.append(brush)
    }

    internal(set) var currentBrush: Brush!
    private(set) var registeredBrushes: [Brush] = []

    func findBrushBy(name: String?) -> Brush? {
        return registeredBrushes.first { $0.name == name }
    }

    private(set) var textures: [MLTexture] = []

    @discardableResult
    override func makeTexture(with data: Data, id: String? = nil) throws -> MLTexture {

        if let id = id, let exists = findTexture(by: id) {
            return exists
        }
        let texture = try super.makeTexture(with: data, id: id)
        textures.append(texture)
        return texture
    }

    func findTexture(by id: String) -> MLTexture? {
        return textures.first { $0.id == id }
    }

    var scale: CGFloat {
        get {
            return screenTarget?.scale ?? 1
        }
        set {
            screenTarget?.scale = newValue
        }
    }

    var zoom: CGFloat {
        get {
            return screenTarget?.zoom ?? 1
        }
        set {
            screenTarget?.zoom = newValue
        }
    }

    var contentOffset: CGPoint {
        get {
            return screenTarget?.contentOffset ?? .zero
        }
        set {
            screenTarget?.contentOffset = newValue
        }
    }

    override func setup() {
        super.setup()

        defaultBrush = Brush(name: "default", textureID: nil, target: self)
        currentBrush = defaultBrush

        printer = Printer(name: "printer", textureID: nil, target: self)
        
        data = CanvasData()
    }

    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, contentScaleFactor)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    override func clear(display: Bool = true) {
        super.clear(display: display)
        
        if display {
            data.appendClearAction()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        redraw()
    }

    private(set) var data: CanvasData!

    func resetData(redraw: Bool = true) {
        let oldData = data!
        let newData = CanvasData()
        newData.observers = data.observers
        data = newData
        if redraw {
            self.redraw()
        }
        data.observers.data(oldData, didResetTo: newData)
    }
    
    func undo() {
        if let data = data, data.undo() {
            redraw()
        }
    }
    
    func redo() {
        if let data = data, data.redo() {
            redraw()
        }
    }

    func redraw(on target: RenderTarget? = nil) {
        
        guard let target = target ?? screenTarget else {
            return
        }
        
        data.finishCurrentElement()
        
        target.updateBuffer(with: drawableSize)
        target.clear()
        
        data.elements.forEach { $0.drawSelf(on: target) }

        target.commitCommands()
        
        actionObservers.canvas(self, didRedrawOn: target)
    }

    func render(lines: [MLLine]) {
        data.append(lines: lines, with: currentBrush)
        LineStrip(lines: lines, brush: currentBrush).drawSelf(on: screenTarget)
        screenTarget?.commitCommands()
    }
    
    func renderTap(at point: CGPoint, to: CGPoint? = nil) {
        
        guard renderingDelegate?.canvas(self, shouldRenderTapAt: point) ?? true else {
            return
        }
        
        let brush = currentBrush!
        let lines = brush.makeLine(from: point, to: to ?? point)
        render(lines: lines)
    }
    
    func renderChartlet(
        at point: CGPoint,
        size: CGSize,
        textureID: String,
        rotation: CGFloat = 0,
        grouped: Bool = false
    ) {
        
        let chartlet = Chartlet(center: point, size: size, textureID: textureID, angle: rotation, canvas: self)
        
        guard renderingDelegate?.canvas(self, shouldRenderChartlet: chartlet) ?? true else {
            return
        }
        
        data.append(chartlet: chartlet, grouped: grouped)
        chartlet.drawSelf(on: screenTarget)
        screenTarget?.commitCommands()
        setNeedsDisplay()
        
        actionObservers.canvas(self, didRenderChartlet: chartlet)
    }
    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pan = firstAvaliablePan(from: touches) else {
            return
        }
        guard renderingDelegate?.canvas(self, shouldBeginLineAt: pan.point, force: pan.force) ?? true else {
            return
        }
        if currentBrush.renderBegan(from: pan, on: self) {
            actionObservers.canvas(self, didBeginLineAt: pan.point, force: pan.force)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pan = firstAvaliablePan(from: touches) else {
            return
        }
        if currentBrush.renderMoved(to: pan, on: self) {
            actionObservers.canvas(self, didMoveLineTo: pan.point, force: pan.force)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pan = firstAvaliablePan(from: touches) else {
            return
        }
        currentBrush.renderEnded(at: pan, on: self)
        data.finishCurrentElement()
        actionObservers.canvas(self, didFinishLineAt: pan.point, force: pan.force)
    }
    
    func firstAvaliablePan(from touches: Set<UITouch>) -> Pan? {
        var touch: UITouch?
        if #available(iOS 9.1, *), isPencilMode {
            touch = touches.first { (t) -> Bool in
                return t.type == .pencil
            }
        } else {
            touch = touches.first
        }
        guard let t = touch else {
            return nil
        }
        return Pan(touch: t, on: self)
    }
}
