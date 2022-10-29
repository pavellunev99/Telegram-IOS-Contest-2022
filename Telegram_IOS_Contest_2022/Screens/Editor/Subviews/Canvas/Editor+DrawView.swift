//
//  Editor+DrawView.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 13.10.2022.
//

import UIKit
import Metal

protocol EditorDrawViewPropertiesDelegate: AnyObject {
    func selectedColor() -> UIColor
}

extension EditorCanvasView {

    final class DrawView: OnDrawAnimatedView {

        weak var delegate: EditorDrawViewPropertiesDelegate?

        private var path: UIBezierPath = UIBezierPath()

        override func setup() {
            super.setup()

            backgroundColor = .clear

            path.lineWidth = 10
            path.lineCapStyle = .round
        }

        override func setupSizes() {
            super.setupSizes()
        }

        override func draw(_ rect: CGRect) {
            super.draw(rect)

            delegate?.selectedColor().set()

            path.stroke()
        }

        func clear() {
            path.removeAllPoints()
            setNeedsDisplay()
        }

        func getImage() -> UIImage? {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        }
    }
}

extension EditorCanvasView.DrawView: ScrollViewTouchesDelegate {

    func scrollViewTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1, let point = touches.first?.location(in: self) else { return }
        path.move(to: point)
    }

    func scrollViewTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1, let point = touches.first?.location(in: self) else { return }
        path.addLine(to: point)
        setNeedsDisplay()
    }

    func scrollViewTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //path = nil
    }
}
