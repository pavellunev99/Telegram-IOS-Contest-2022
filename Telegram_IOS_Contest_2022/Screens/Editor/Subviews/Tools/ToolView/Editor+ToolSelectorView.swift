//
//  Editor+ToolSelectorView.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 30.10.2022.
//

import UIKit

final class ToolSelectorView: View {

    let availableTools: [EditorTool] = [
        .init(toolType: .pen),
        .init(toolType: .brush),
        .init(toolType: .neon),
        .init(toolType: .pencil),
        .init(toolType: .lasso),
        .init(toolType: .eraser)
    ]

    let stackView = UIStackView()
    let gradientLayer = CAGradientLayer()

    var selectedTool: ToolView?

    override func setup() {
        super.setup()

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        gradientLayer.colors = [UIColor.black.cgColor,
                                UIColor.black.cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.locations =  [0.0, 0.8, 1.0]
        stackView.layer.mask = gradientLayer

        availableTools.forEach {

            let toolView: ToolView

            switch $0.toolType {
            case .pen:
                toolView = PenToolView()
            case .brush:
                toolView = BrushToolView()
            case .neon:
                toolView = NeonToolView()
            case .pencil:
                toolView = PencilToolView()
            case .lasso:
                toolView = LassoToolView()
            case .eraser:
                toolView = EraserToolView()
            }

            toolView.addTarget(self, action: #selector(tapTool), for: .touchUpInside)
            stackView.addArrangedSubview(toolView)
        }
    }

    @objc
    private func tapTool(_ toolView: ToolView) {
        if selectedTool == toolView {
            selectedTool = nil
        } else {
            selectedTool = toolView
        }

        stackView.arrangedSubviews.forEach {
            guard let toolView = $0 as? ToolView else { return }
            toolView.isSelected = selectedTool == $0
        }
    }

    override func setupSizes() {
        super.setupSizes()

        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = stackView.frame
    }
}
