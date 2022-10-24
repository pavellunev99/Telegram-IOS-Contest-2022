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

        override func setup() {
            super.setup()

            editorControl.translatesAutoresizingMaskIntoConstraints = false
            editorControl.selectedSegmentIndex = 0
            editorControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
            editorControl.backgroundColor = .white.withAlphaComponent(0.1)
            addSubview(editorControl)

            toolsSelector.translatesAutoresizingMaskIntoConstraints = false
            addSubview(toolsSelector)

        }

        override func setupSizes() {
            super.setupSizes()

            heightAnchor.constraint(equalToConstant: 146).isActive = true

            editorControl.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            editorControl.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            editorControl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

            toolsSelector.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            toolsSelector.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            toolsSelector.bottomAnchor.constraint(equalTo: editorControl.topAnchor).isActive = true
            toolsSelector.topAnchor.constraint(equalTo: topAnchor).isActive = true

            toolsSelector.setContentHuggingPriority(.defaultLow, for: .horizontal)
            toolsSelector.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }

        @objc
        private func indexChanged(_ control: UISegmentedControl) {
            switch control.selectedSegmentIndex {
            case 0:
                delegate?.centerViewDrawEditorSelected()
            case 1:
                delegate?.centerViewTextEditorSelected()
            default:
                break
            }
        }
    }

    final class ToolSelectorView: View {

        let availableTools: [EditorTool] = [
            .init(toolType: .brush),
            .init(toolType: .marker),
            .init(toolType: .neon),
            .init(toolType: .pencil),
            .init(toolType: .lasso),
            .init(toolType: .eraser)
        ]

        let stackView = UIStackView()

        override func setup() {
            super.setup()

            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 16
            stackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stackView)

            availableTools.forEach {
                let toolView = ToolView()
                toolView.tool = $0
                stackView.addArrangedSubview(toolView)
            }
        }

        override func setupSizes() {
            super.setupSizes()

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }
    }

    final class ToolView: View {

        var tool: EditorTool? {
            didSet {
                _update()
            }
        }

        private func _update() {
            guard let tool = tool else { return }

            switch tool.toolType {
            case .brush:
                backgroundColor = .red
            case .marker:
                backgroundColor = .blue
            case .neon:
                backgroundColor = .yellow
            case .pencil:
                backgroundColor = .green
            case .lasso:
                backgroundColor = .cyan
            case .eraser:
                backgroundColor = .white
            }
        }

        override func setup() {
            super.setup()
        }

        override func setupSizes() {
            super.setupSizes()
        }
    }
}
