//
//  Editor+ToolView.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 30.10.2022.
//

import UIKit

class ToolView: View {

    var tool: EditorTool?

    let containerView = View()
    let bodyImageView = UIImageView()
    let topImageView = UIImageView()
    let colorView = View()

    override var isSelected: Bool {
        didSet {
            _bottomSelected?.isActive = isSelected
            _bottomUnselected?.isActive = !isSelected

            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        }
    }

    private var colorSizeConstraint: NSLayoutConstraint?

    var color: UIColor? {
        didSet {
            topImageView.tintColor = color
            colorView.backgroundColor = color
        }
    }

    var lineSize: CGFloat? {
        didSet {
            colorSizeConstraint?.constant = lineSize ?? 1

            colorView.setNeedsLayout()
            colorView.layoutIfNeeded()
        }
    }

    private var _bottomSelected: NSLayoutConstraint?
    private var _bottomUnselected: NSLayoutConstraint?

    override func setup() {
        super.setup()

        layer.masksToBounds = true

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.isUserInteractionEnabled = false
        addSubview(containerView)

        bodyImageView.contentMode = .scaleAspectFit
        bodyImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bodyImageView)

        topImageView.contentMode = .scaleAspectFit
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(topImageView)

        colorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(colorView)
        colorView.isHidden = true
    }

    override func setupSizes() {
        super.setupSizes()

        heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true

        containerView.heightAnchor.constraint(equalToConstant: 83).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 17).isActive = true
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        _bottomUnselected = containerView.topAnchor.constraint(equalTo: topAnchor, constant: 25)
        _bottomUnselected?.isActive = true

        _bottomSelected = containerView.topAnchor.constraint(equalTo: topAnchor)

        bodyImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        bodyImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        bodyImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        bodyImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        topImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        topImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        topImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        topImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        colorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        colorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        colorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true

        colorSizeConstraint = colorView.heightAnchor.constraint(equalToConstant: 1)
        colorSizeConstraint?.isActive = true
    }
}

class PenToolView: ToolView {

    override func setup() {
        super.setup()

        bodyImageView.image = .init(named: "pen")
        topImageView.image = .init(named: "pen-end")

        color = .white
        lineSize = 20
    }

    override func setupSizes() {
        super.setupSizes()
    }
}

class BrushToolView: ToolView {

    override func setup() {
        super.setup()

        bodyImageView.image = .init(named: "brush")
        topImageView.image = .init(named: "brush-end")

        color = .yellow
        lineSize = 20
    }

    override func setupSizes() {
        super.setupSizes()
    }
}

class NeonToolView: ToolView {

    override func setup() {
        super.setup()

        bodyImageView.image = .init(named: "neon")
        topImageView.image = .init(named: "neon-end")

        color = .green
        lineSize = 5
    }

    override func setupSizes() {
        super.setupSizes()
    }
}

class PencilToolView: ToolView {

    override func setup() {
        super.setup()

        bodyImageView.image = .init(named: "pencil")
        topImageView.image = .init(named: "pencil-end")

        color = .yellow
        lineSize = 10
    }

    override func setupSizes() {
        super.setupSizes()
    }
}

class LassoToolView: ToolView {

    override func setup() {
        super.setup()

        bodyImageView.image = .init(named: "lasso")
    }

    override func setupSizes() {
        super.setupSizes()
    }
}

class EraserToolView: ToolView {

    override func setup() {
        super.setup()

        bodyImageView.image = .init(named: "eraser")
    }

    override func setupSizes() {
        super.setupSizes()
    }
}
