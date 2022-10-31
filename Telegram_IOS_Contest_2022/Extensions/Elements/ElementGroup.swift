//
//  ElementGroup.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import Foundation

class ElementGroup<E: CanvasElement>: CanvasElement {
        
    /// index in the emelent list of canvas
    /// element with smaller index will draw earlier
    /// Automatically set by Canvas.Data
    var index: Int = 0
    
    var elements: [E] = []
    
    /// draw this element on specifyied target
    func drawSelf(on target: RenderTarget?) {
        elements.forEach {
            $0.drawSelf(on: target)
        }
    }
    
    func append(_ element: E) {
        elements.append(element)
    }
}

