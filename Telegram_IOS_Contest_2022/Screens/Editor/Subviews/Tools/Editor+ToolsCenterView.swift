//
//  Editor+ToolsCenterView.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 15.10.2022.
//

import UIKit

protocol EditorToolsCenterViewDelegate: AnyObject {
    func centerViewDrawEditorSelected()
    func centerViewTextEditorSelected()
}

extension EditorToolsView {

    final class CenterView: View {

        weak var delegate: EditorToolsCenterViewDelegate?

        let editorControl = UISegmentedControl(items: ["Draw", "Text"])
        let toolsSelector = ToolSelectorView()
        let textsSelectors = TextPropertiesSelectorView()

        override func setup() {
            super.setup()

            editorControl.translatesAutoresizingMaskIntoConstraints = false
            editorControl.selectedSegmentIndex = 0
            editorControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
            editorControl.backgroundColor = .white.withAlphaComponent(0.1)
            addSubview(editorControl)

            toolsSelector.translatesAutoresizingMaskIntoConstraints = false
            addSubview(toolsSelector)

            textsSelectors.translatesAutoresizingMaskIntoConstraints = false
            textsSelectors.isHidden = true
            addSubview(textsSelectors)
        }

        override func setupSizes() {
            super.setupSizes()

            editorControl.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            editorControl.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            editorControl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

            toolsSelector.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            toolsSelector.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            toolsSelector.bottomAnchor.constraint(equalTo: editorControl.topAnchor).isActive = true
            toolsSelector.topAnchor.constraint(equalTo: topAnchor).isActive = true

            toolsSelector.setContentHuggingPriority(.defaultLow, for: .horizontal)
            toolsSelector.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

            textsSelectors.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            textsSelectors.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            textsSelectors.bottomAnchor.constraint(equalTo: editorControl.topAnchor, constant: -16).isActive = true
        }

        @objc
        private func indexChanged(_ control: UISegmentedControl) {
            switch control.selectedSegmentIndex {
            case 0:
                toolsSelector.isHidden = false
                textsSelectors.isHidden = true
                delegate?.centerViewDrawEditorSelected()
            case 1:
                toolsSelector.isHidden = true
                textsSelectors.isHidden = false
                delegate?.centerViewTextEditorSelected()
            default:
                break
            }
        }
    }
}
