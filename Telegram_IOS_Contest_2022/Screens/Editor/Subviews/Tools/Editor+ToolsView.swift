//
//  Editor+ToolsView.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 13.10.2022.
//

import UIKit

protocol EditorToolsViewDelegate: AnyObject {
    func toolsViewTapSave()
    func toolsViewTapClose()
    func toolsViewTapSelectColor()
    func centerViewDrawEditorSelected()
    func centerViewTextEditorSelected()
}

final class EditorToolsView: View {

    let leftView = LeftView()
    let rightView = RightView()
    let centerView = CenterView()

    weak var delegate: EditorToolsViewDelegate?

    override func setup() {
        super.setup()

        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftView.delegate = self
        addSubview(leftView)

        centerView.translatesAutoresizingMaskIntoConstraints = false
        centerView.delegate = self
        addSubview(centerView)

        rightView.translatesAutoresizingMaskIntoConstraints = false
        rightView.delegate = self
        addSubview(rightView)

        leftView.setContentHuggingPriority(.required, for: .horizontal)
        leftView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    override func setupSizes() {
        super.setupSizes()

        leftView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        leftView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        leftView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        rightView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        rightView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        rightView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        centerView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: 16).isActive = true
        centerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        centerView.trailingAnchor.constraint(equalTo: rightView.leadingAnchor, constant: -16).isActive = true
        centerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
}

extension EditorToolsView: EditorToolsLeftViewDelegate {

    func tapSelectColor() {
        delegate?.toolsViewTapSelectColor()
    }

    func tapClose() {
        delegate?.toolsViewTapClose()
    }
}

extension EditorToolsView: EditorToolsRightViewDelegate {

    func tapAdd() {

    }

    func tapSave() {
        delegate?.toolsViewTapSave()
    }
}

extension EditorToolsView: EditorToolsCenterViewDelegate {

    func centerViewDrawEditorSelected() {
        delegate?.centerViewDrawEditorSelected()
    }

    func centerViewTextEditorSelected() {
        delegate?.centerViewTextEditorSelected()
    }
}
