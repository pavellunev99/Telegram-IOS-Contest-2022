//
//  GlowingBrush.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import Foundation
import CoreGraphics
import Metal
import UIKit

final class GlowingBrush: Brush {

    var coreProportion: CGFloat = 0.25

    var coreColor: UIColor = .white {
        didSet {
            subBrush.color = coreColor
        }
    }
    
    override var pointSize: CGFloat {
        didSet {
            subBrush.pointSize = pointSize * coreProportion
        }
    }
    override var pointStep: CGFloat {
        didSet {
            subBrush.pointStep = 1
        }
    }
    override var forceSensitive: CGFloat {
        didSet {
            subBrush.forceSensitive = forceSensitive
        }
    }
    override var scaleWithCanvas: Bool {
        didSet {
            subBrush.scaleWithCanvas = scaleWithCanvas
        }
    }
    override var forceOnTap: CGFloat {
        didSet {
            subBrush.forceOnTap = forceOnTap
        }
    }

    private var subBrush: Brush!

    private var pendingCoreLines: [MLLine] = []

    required init(name: String?, textureID: String?, target: Canvas) {
        super.init(name: name, textureID: textureID, target: target)
        subBrush = Brush(name: self.name + ".sub", textureID: nil, target: target)
        subBrush.color = coreColor
        subBrush.opacity = 10
    }

    override func makeLine(from: CGPoint, to: CGPoint, force: CGFloat? = nil, uniqueColor: Bool = false) -> [MLLine] {
        let shadowLines = super.makeLine(from: from, to: to, force: force)
        let delta = (pointSize * (1 - coreProportion)) / 2
        var coreLines: [MLLine] = []
        
        while let first = pendingCoreLines.first?.begin, first.distance(to: from) >= delta {
            coreLines.append(pendingCoreLines.removeFirst())
        }
        let lines = subBrush.makeLine(from: from, to: to, force: force, uniqueColor: true)
        pendingCoreLines.append(contentsOf: lines)
        return shadowLines + coreLines
    }
    
    override func finishLineStrip(at end: Pan) -> [MLLine] {
        let lines = pendingCoreLines
        pendingCoreLines.removeAll()
        return lines
    }
}

