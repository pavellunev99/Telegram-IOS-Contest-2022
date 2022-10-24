//
//  Editor+DrawView.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 13.10.2022.
//

import UIKit

extension EditorCanvasView {

    final class DrawView: View {

        var canvasSize: CGSize = .zero {
            didSet {
                imageView.image = UIImage.imageWithSize(size: canvasSize)
            }
        }

        var image: UIImage? {
            imageView.image
        }

        var lastPoint = CGPoint.zero
        var brushWidth: CGFloat = 10.0
        var opacity: CGFloat = 1.0
        var swiped = false

        private let imageView = UIImageView()

        override func setup() {
            super.setup()

            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.backgroundColor = .clear
        }

        override func setupSizes() {
            super.setupSizes()

            imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }

        func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {

            UIGraphicsBeginImageContext(frame.size)

            let context = UIGraphicsGetCurrentContext()
            imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))

            context?.move(to: fromPoint)
            context?.addLine(to: toPoint)

            context?.setLineCap(.round)
            context?.setLineWidth(brushWidth)
            context?.setStrokeColor(UIColor.red.cgColor)
            context?.setBlendMode(.normal)

            context?.strokePath()

            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            //tempImageView.alpha = opacity

            UIGraphicsEndImageContext()
        }

        func clear() {
            imageView.image = UIImage.imageWithSize(size: canvasSize)
        }
    }
}

extension EditorCanvasView.DrawView: ScrollViewTouchesDelegate {

    func scrollViewTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        swiped = false
        if let point = touches.first?.location(in: self) {
            lastPoint = point
        }
    }

    func scrollViewTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)

            lastPoint = currentPoint
        }
    }
}

extension UIImage {

    static func imageWithPixelSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, opaque: Bool = false) -> UIImage? {
        return imageWithSize(size: size, filledWithColor: color, scale: 1.0, opaque: opaque)
    }

    static func imageWithSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, scale: CGFloat = 0.0, opaque: Bool = false) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        color.set()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
