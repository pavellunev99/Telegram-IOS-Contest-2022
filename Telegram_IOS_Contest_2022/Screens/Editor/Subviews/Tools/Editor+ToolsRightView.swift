//
//  Editor+ToolsRightView.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 15.10.2022.
//

import UIKit

protocol EditorToolsRightViewDelegate: AnyObject {
    func tapAdd()
    func tapSave()
}

extension EditorToolsView {

    final class RightView: View {

        weak var delegate: EditorToolsRightViewDelegate?

        private let addButton = CircleButton()
        private let saveButton = Button()

        override func setup() {
            super.setup()

            addButton.translatesAutoresizingMaskIntoConstraints = false
            addButton.addTarget(self, action: #selector(tapAdd), for: .touchUpInside)
            addButton.imageView.image = .init(named: "add")
            addButton.backgroundView.backgroundColor = .white
            addButton.backgroundView.alpha = 0.1
            addSubview(addButton)

            saveButton.translatesAutoresizingMaskIntoConstraints = false
            saveButton.addTarget(self, action: #selector(tapSave), for: .touchUpInside)
            saveButton.imageView.image = .init(named: "download")
            addSubview(saveButton)
        }

        override func setupSizes() {
            super.setupSizes()

            let buttonSide: CGFloat = 32

            addButton.widthAnchor.constraint(equalToConstant: buttonSide).isActive = true
            addButton.heightAnchor.constraint(equalToConstant: buttonSide).isActive = true

            addButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            addButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -16).isActive = true

            saveButton.widthAnchor.constraint(equalToConstant: buttonSide).isActive = true
            saveButton.heightAnchor.constraint(equalToConstant: buttonSide).isActive = true

            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }

        @objc
        private func tapAdd() {
            delegate?.tapAdd()
        }

        @objc
        private func tapSave() {
            delegate?.tapSave()
        }
    }
}
