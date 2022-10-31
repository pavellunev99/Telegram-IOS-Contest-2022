//
//  Editor+ToolsLeftView.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 15.10.2022.
//

import UIKit

protocol EditorToolsLeftViewDelegate: AnyObject {
    func tapSelectColor()
    func tapClose()
}

extension EditorToolsView {

    final class LeftView: View {

        weak var delegate: EditorToolsLeftViewDelegate?

        private let colorsButton = ColorsButton()
        private let closeButton = Button()

        override func setup() {
            super.setup()

            colorsButton.translatesAutoresizingMaskIntoConstraints = false
            colorsButton.addTarget(self, action: #selector(tapSelectColor), for: .touchUpInside)
            addSubview(colorsButton)

            closeButton.translatesAutoresizingMaskIntoConstraints = false
            closeButton.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
            closeButton.imageView.image = .init(named: "cancel")
            addSubview(closeButton)
        }

        override func setupSizes() {
            super.setupSizes()

            let buttonSide: CGFloat = 32

            colorsButton.widthAnchor.constraint(equalToConstant: buttonSide).isActive = true
            colorsButton.heightAnchor.constraint(equalToConstant: buttonSide).isActive = true

            colorsButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            colorsButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            colorsButton.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -16).isActive = true

            closeButton.widthAnchor.constraint(equalToConstant: buttonSide).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: buttonSide).isActive = true

            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            closeButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }

        @objc
        private func tapSelectColor() {
            delegate?.tapSelectColor()
        }

        @objc
        private func tapClose() {
            delegate?.tapClose()
        }
    }

    final class ColorsButton: View {

        private let circle = RainbowCircle()
        private var circleLayer = CAShapeLayer()

        override func setup() {
            super.setup()

            backgroundColor = .clear

            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.lineHeight = 3
            circle.isUserInteractionEnabled = false
            addSubview(circle)

            layer.addSublayer(circleLayer)
            circleLayer.fillColor = UIColor.white.cgColor
        }

        override func setupSizes() {
            super.setupSizes()

            circle.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            circle.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            circle.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            circle.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }

        override func draw(_ rect: CGRect) {
            super.draw(rect)

            let radius: CGFloat = rect.height * 0.3
            circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius), cornerRadius: radius).cgPath
            circleLayer.position = CGPoint(x: rect.midX - radius, y: rect.midY - radius)
        }
    }
}
