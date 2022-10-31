//
//  RainbowCircle.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 31.10.2022.
//

import UIKit

class RainbowCircle: View {

    private var radius: CGFloat {
        return frame.width>frame.height ? frame.height/2 : frame.width/2
    }

    private var padding: CGFloat = 0

    var lineHeight: CGFloat = 5 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func setup() {
        super.setup()

        backgroundColor = .clear
    }

    override func setupSizes() {
        super.setupSizes()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawRainbowCircle(outerRadius: radius - padding, innerRadius: radius - lineHeight - padding, resolution: 1)
    }

    private func drawRainbowCircle(outerRadius: CGFloat, innerRadius: CGFloat, resolution: Float) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        context.translateBy(x: self.bounds.midX, y: self.bounds.midY)

        let subdivisions:CGFloat = CGFloat(resolution * 512)

        let innerHeight = (CGFloat.pi*innerRadius)/subdivisions
        let outterHeight = (CGFloat.pi*outerRadius)/subdivisions

        let segment = UIBezierPath()
        segment.move(to: CGPoint(x: innerRadius, y: -innerHeight/2))
        segment.addLine(to: CGPoint(x: innerRadius, y: innerHeight/2))
        segment.addLine(to: CGPoint(x: outerRadius, y: outterHeight/2))
        segment.addLine(to: CGPoint(x: outerRadius, y: -outterHeight/2))
        segment.close()

        for i in 0 ..< Int(ceil(subdivisions)) {
            UIColor(hue: CGFloat(i)/subdivisions, saturation: 1, brightness: 1, alpha: 1).set()
            segment.fill()
            let lineTailSpace = CGFloat.pi*2*outerRadius/subdivisions
            segment.lineWidth = lineTailSpace
            segment.stroke()

            let rotate = CGAffineTransform(rotationAngle: -(CGFloat.pi*2/subdivisions))
            segment.apply(rotate)
        }

        context.translateBy(x: -self.bounds.midX, y: -self.bounds.midY)
        context.restoreGState()
    }
}
