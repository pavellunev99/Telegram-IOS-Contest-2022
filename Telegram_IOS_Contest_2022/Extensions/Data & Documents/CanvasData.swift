//
//  CanvasData.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import Foundation

/// base element that can be draw on canvas
protocol CanvasElement: Codable {
    
    /// index in the emelent list of canvas
    /// element with smaller index will draw earlier
    /// Automatically set by Canvas.Data
    var index: Int { get set }
    
    /// draw this element on specifyied target
    func drawSelf(on target: RenderTarget?)
}

/// clear action, a command to clear the canvas
struct ClearAction: CanvasElement {
    var index: Int = 0
    func drawSelf(on target: RenderTarget?) {
        target?.clear()
    }
}

/// content data on canvas
class CanvasData {
    
    /// elements array before an clear action, avoid to change this value when drawing
    var clearedElements: [[CanvasElement]] = []
    
    /// current drawing elements, avoid to change this value when drawing
    var elements: [CanvasElement] = []
    
    /// current unfinished element, avoid to change this value when drawing
    var currentElement: CanvasElement?
    
    /// Append a set of lines to current element in document
    ///
    /// - Parameters:
    ///   - lines: lines to add
    ///   - brush: brush used to draw these lines
    ///   - isNewElement: if sets true, current line strip will be set to finished and a new one will be setup
    func append(lines: [MLLine], with brush: Brush) {
        guard lines.count > 0 else {
            return
        }
        // append lines to current line strip
        if let lineStrip = currentElement as? LineStrip, lineStrip.brush === brush {
            lineStrip.append(lines: lines)
        } else {
            finishCurrentElement()
            
            let lineStrip = LineStrip(lines: lines, brush: brush)
            currentElement = lineStrip
            undoArray.removeAll()
            
            observers.lineStrip(lineStrip, didBeginOn: self)
            h_onElementBegin?(self)
        }
    }
        
    /// add a chartlet to elements
    /// - Parameters:
    ///   - grouped: if grouped, a ChartletGroup will be created
    func append(chartlet: Chartlet, grouped: Bool = false) {
        
        if !grouped {
            currentElement = chartlet
            finishCurrentElement()
        } else if let group = currentElement as? ElementGroup<Chartlet> {
            group.append(chartlet)
        } else {
            let group = ElementGroup<Chartlet>()
            currentElement = group
            group.append(chartlet)
        }
    }
    
    /// index for latest element
    var lastElementIndex: Int {
        return elements.last?.index ?? 0
    }
    
    func finishCurrentElement() {
        guard var element = currentElement else {
            return
        }
        element.index = lastElementIndex + 1
        elements.append(element)
        currentElement = nil
        undoArray.removeAll()
        
        observers.element(element, didFinishOn: self)
        h_onElementFinish?(self)
    }
    
    func appendClearAction() {
        finishCurrentElement()
        
        guard elements.count > 0 else {
            return
        }
        clearedElements.append(elements)
        elements.removeAll()
        undoArray.removeAll()
        
        observers.dataDidClear(self)
    }
    
    // MARK: - Undo & Redo
    var canRedo: Bool {
        return undoArray.count > 0
    }
    
    var canUndo: Bool {
        return elements.count > 0 || clearedElements.count > 0
    }
    
    private(set) var undoArray: [CanvasElement] = []
    
    internal func undo() -> Bool {
        finishCurrentElement()
        
        if let last = elements.last {
            undoArray.append(last)
            elements.removeLast()
        } else if let lastCleared = clearedElements.last {
            undoArray.append(ClearAction())
            elements = lastCleared
            clearedElements.removeLast()
        } else {
            return false
        }
        observers.dataDidUndo(self)
        h_onUndo?(self)
        return true
    }
    
    internal func redo() -> Bool {
        guard currentElement == nil, let last = undoArray.last else {
            return false
        }
        if let _ = last as? ClearAction {
            clearedElements.append(elements)
            elements.removeAll()
        } else {
            elements.append(last)
        }
        undoArray.removeLast()
        observers.dataDidRedo(self)
        h_onRedo?(self)
        return true
    }
    
    // MARK: - Observers
    internal var observers = DataObserverPool()
    
    // add an observer to observe data changes, observers are not retained
    func addObserver(_ observer: DataObserver) {
        // pure nil objects
        observers.clean()
        observers.addObserver(observer)
    }
    
    // MARK: - EventHandler
    typealias EventHandler = (CanvasData) -> ()
    
    private var h_onElementBegin: EventHandler?
    private var h_onElementFinish: EventHandler?
    private var h_onRedo: EventHandler?
    private var h_onUndo: EventHandler?
    
    @available(*, deprecated, message: "Use Observers instead")
    @discardableResult
    func onElementBegin(_ h: @escaping EventHandler) -> Self {
        h_onElementBegin = h
        return self
    }
    
    @available(*, deprecated, message: "Use Observers instead")
    @discardableResult
    func onElementFinish(_ h: @escaping EventHandler) -> Self {
        h_onElementFinish = h
        return self
    }
    
    @available(*, deprecated, message: "Use Observers instead")
    @discardableResult
    func onRedo(_ h: @escaping EventHandler) -> Self {
        h_onRedo = h
        return self
    }
    
    @available(*, deprecated, message: "Use Observers instead")
    @discardableResult
    func onUndo(_ h: @escaping EventHandler) -> Self {
        h_onUndo = h
        return self
    }
}
