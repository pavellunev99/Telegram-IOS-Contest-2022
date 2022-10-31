//
//  ActionObserver.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import Foundation
import UIKit

protocol RenderingDelegate: AnyObject {
    func canvas(_ canvas: Canvas, shouldRenderTapAt point: CGPoint) -> Bool
    func canvas(_ canvas: Canvas, shouldRenderChartlet chartlet: Chartlet) -> Bool
    func canvas(_ canvas: Canvas, shouldBeginLineAt point: CGPoint, force: CGFloat) -> Bool
}

extension RenderingDelegate {
    func canvas(_ canvas: Canvas, shouldRenderTapAt point: CGPoint) -> Bool {
        return true
    }
    
    func canvas(_ canvas: Canvas, shouldRenderChartlet chartlet: Chartlet) -> Bool {
        return true
    }
    
    func canvas(_ canvas: Canvas, shouldBeginLineAt point: CGPoint, force: CGFloat) -> Bool {
        return true
    }
}

protocol ActionObserver: AnyObject {
    
    func canvas(_ canvas: Canvas, didRenderTapAt point: CGPoint)
    func canvas(_ canvas: Canvas, didRenderChartlet chartlet: Chartlet)

    func canvas(_ canvas: Canvas, didBeginLineAt point: CGPoint, force: CGFloat)
    func canvas(_ canvas: Canvas, didMoveLineTo point: CGPoint, force: CGFloat)
    func canvas(_ canvas: Canvas, didFinishLineAt point: CGPoint, force: CGFloat)
    
    func canvas(_ canvas: Canvas, didRedrawOn target: RenderTarget)
}

extension ActionObserver {
    
    func canvas(_ canvas: Canvas, didRenderTapAt point: CGPoint) {}
    func canvas(_ canvas: Canvas, didRenderChartlet chartlet: Chartlet) {}
    
    func canvas(_ canvas: Canvas, didBeginLineAt point: CGPoint, force: CGFloat) {}
    func canvas(_ canvas: Canvas, didMoveLineTo point: CGPoint, force: CGFloat) {}
    func canvas(_ canvas: Canvas, didFinishLineAt point: CGPoint, force: CGFloat) {}
    
    func canvas(_ canvas: Canvas, didRedrawOn target: RenderTarget) {}
}

final class ActionObserverPool: WeakObjectsPool {
    
    func addObserver(_ observer: ActionObserver) {
        super.addObject(observer)
    }

    var aliveObservers: [ActionObserver] {
        return aliveObjects.compactMap { $0 as? ActionObserver }
    }
}

extension ActionObserverPool: ActionObserver {
    
    func canvas(_ canvas: Canvas, didRenderTapAt point: CGPoint) {
        aliveObservers.forEach { $0.canvas(canvas, didRenderTapAt: point) }
    }
    func canvas(_ canvas: Canvas, didRenderChartlet chartlet: Chartlet) {
        aliveObservers.forEach { $0.canvas(canvas, didRenderChartlet: chartlet) }
    }
    
    func canvas(_ canvas: Canvas, didBeginLineAt point: CGPoint, force: CGFloat) {
        aliveObservers.forEach { $0.canvas(canvas, didBeginLineAt: point, force: force) }
    }
    
    func canvas(_ canvas: Canvas, didMoveLineTo point: CGPoint, force: CGFloat) {
        aliveObservers.forEach { $0.canvas(canvas, didMoveLineTo: point, force: force) }
    }
    
    func canvas(_ canvas: Canvas, didFinishLineAt point: CGPoint, force: CGFloat) {
        aliveObservers.forEach { $0.canvas(canvas, didFinishLineAt: point, force: force) }
    }

    func canvas(_ canvas: Canvas, didRedrawOn target: RenderTarget) {
        aliveObservers.forEach { $0.canvas(canvas, didRedrawOn: target) }
    }
}
