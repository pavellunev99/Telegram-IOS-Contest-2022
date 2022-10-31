//
//  ColorSelector+Spectrum.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 31.10.2022.
//

import UIKit

internal protocol SpectrumSelectorViewDelegate : NSObjectProtocol {
    func specturmSelectorColorSelected(_ color: UIColor)
}

extension ColorSelectorViewController {

    final class SpectrumSelectorView: View {

        weak var delegate: SpectrumSelectorViewDelegate?
        let saturationExponentTop:Float = 2.0
        let saturationExponentBottom:Float = 1.3

        var elementSize: CGFloat = 1.0 {
            didSet {
                setNeedsDisplay()
            }
        }

        override func setup() {
            super.setup()

            layer.masksToBounds = true
            layer.cornerRadius = 10

            clipsToBounds = true
        }

        override func setupSizes() {
            super.setupSizes()
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)

            guard let point = touches.first?.location(in: self) else { return }
            touchedColor(point: point)
        }

        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesMoved(touches, with: event)

            guard let point = touches.first?.location(in: self) else { return }
            touchedColor(point: point)
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
        }

        override func draw(_ rect: CGRect) {
            let context = UIGraphicsGetCurrentContext()

//            for y : CGFloat in stride(from: 0.0 ,to: rect.height, by: elementSize) {
//                var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
//                saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
//                let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
//                for x : CGFloat in stride(from: 0.0 ,to: rect.width, by: elementSize) {
//                    let hue = x / rect.width
//                    let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
//                    context!.setFillColor(color.cgColor)
//                    context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
//                }
//            }

            for x : CGFloat in stride(from: 0.0 ,to: rect.width, by: elementSize) {

                var saturation = x < rect.width / 2.0 ? CGFloat(2 * x) / rect.height : 2.0 * CGFloat(rect.width - x) / rect.width
                saturation = CGFloat(powf(Float(saturation), x < rect.width / 2.0 ? saturationExponentTop : saturationExponentBottom))
                let brightness = x < rect.width / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.width - x) / rect.width

                for y : CGFloat in stride(from: 0.0 ,to: rect.height, by: elementSize) {
                    let hue = y / rect.height
                    let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                    context!.setFillColor(color.cgColor)
                    context!.fill(CGRect(x: x, y: y, width: elementSize, height: elementSize))
                }
            }
        }

        func getColorAtPoint(point:CGPoint) -> UIColor {
            let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                       y:elementSize * CGFloat(Int(point.y / elementSize)))
            var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
            : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height

            saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))

            let brightness = roundedPoint.x < self.bounds.width / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.width - roundedPoint.x) / self.bounds.width

            let hue = roundedPoint.y / self.bounds.height

            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        }

        private func touchedColor(point: CGPoint) {
            let color = getColorAtPoint(point: point)
            delegate?.specturmSelectorColorSelected(color)
        }
    }
}
