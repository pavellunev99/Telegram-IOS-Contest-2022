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

        private let colorsButton = Button()
        private let closeButton = Button()

        override func setup() {
            super.setup()

            colorsButton.translatesAutoresizingMaskIntoConstraints = false
            colorsButton.addTarget(self, action: #selector(tapSelectColor), for: .touchUpInside)
            colorsButton.imageView.image = .init(named: "colorPicker")
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
}
