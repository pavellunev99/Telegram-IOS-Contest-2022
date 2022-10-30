//
//  Editor+TextsView.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 23.10.2022.
//

import UIKit

protocol EditorTextsViewDelegate: AnyObject {
    func editorTextsViewFont() -> UIFont
    func editorTextsViewColor() -> UIColor
    func editorTextsViewAlignment() -> NSTextAlignment
}

extension EditorCanvasView {

    final class TextsView: View {

        weak var delegate: EditorTextsViewDelegate?

        override func setup() {
            super.setup()

            inputTextView.delegate = self
            inputTextView.isHidden = true
            addSubview(inputTextView)
        }

        private weak var editingView: TextItemView? {
            didSet {
                inputTextView.text = editingView?.text
                inputTextView.becomeFirstResponder()
                _updateEditingViewState()
            }
        }

        private var inputTextView = UITextView()

        func updateEditingViewStyle() {
            if let editingView = editingView {
                editingView.font = delegate?.editorTextsViewFont()
                editingView.textColor = delegate?.editorTextsViewColor()
                editingView.textAlignment = delegate?.editorTextsViewAlignment()
            }
        }

        func clear() {
            editingView = nil
            subviews.forEach {
                guard $0 is TextItemView else { return }
                $0.removeFromSuperview()
            }
        }

        func getImage() -> UIImage? {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        }

        private func _updateEditingViewState() {
            subviews.forEach {
                guard let textView = $0 as? TextItemView else { return }
                textView.isEditing = textView == editingView
            }
        }

        private func addText(at point: CGPoint) {
            let textView = TextItemView()
            textView.translatesAutoresizingMaskIntoConstraints = false

            textView.font = delegate?.editorTextsViewFont()
            textView.textColor = delegate?.editorTextsViewColor()
            textView.textAlignment = delegate?.editorTextsViewAlignment()

            addSubview(textView)
            textView.centerPoint = point
            editingView = textView
        }
    }
}

extension EditorCanvasView.TextsView: ScrollViewTouchesDelegate {

    func scrollViewTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1,
              let point = touches.first?.location(in: self),
              frame.contains(point)
        else { return }

        if let view = subviews.first(where: { $0.frame.contains(point) }),
           let textView = view as? TextItemView {
            editingView = textView
        } else {
            addText(at: point)
        }
    }

    func scrollViewTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1,
              let point = touches.first?.location(in: self),
              frame.contains(point)
        else { return }
        
        if let editingView = editingView {
            bringSubviewToFront(editingView)
            editingView.centerPoint = point
        }
    }

    func scrollViewTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}

extension EditorCanvasView.TextsView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        editingView?.text = inputTextView.text
    }
}

extension EditorCanvasView.TextsView {

    fileprivate final class TextItemView: View {

        private let label = UILabel()

        var centerPoint: CGPoint = .zero {
            didSet {

                setNeedsLayout()
                layoutIfNeeded()

                let xPoint = centerPoint.x - frame.width/2
                let yPoint = centerPoint.y - frame.height/2

                if let horizontalConstraint = horizontalConstraint {
                    horizontalConstraint.constant = xPoint
                } else {
                    horizontalConstraint = leadingAnchor
                        .constraint(equalTo: superview!.leadingAnchor, constant: xPoint)
                    horizontalConstraint?.isActive = true
                }

                if let verticalConstraint = verticalConstraint {
                    verticalConstraint.constant = yPoint
                } else {
                    verticalConstraint = topAnchor
                        .constraint(equalTo: superview!.topAnchor, constant: yPoint)
                    verticalConstraint?.isActive = true
                }
            }
        }

        private var horizontalConstraint: NSLayoutConstraint?
        private var verticalConstraint: NSLayoutConstraint?

        var font: UIFont? {
            didSet {
                label.font = font
            }
        }

        var textColor: UIColor? {
            didSet {
                label.textColor = textColor
            }
        }

        var text: String? {
            get {
                label.text
            }

            set {
                label.text = newValue
            }
        }

        var textAlignment: NSTextAlignment? {
            didSet {
                label.textAlignment = textAlignment ?? .left
            }
        }

        var isEditing: Bool = false {
            didSet {
                //backgroundColor = isEditing ? .green : .red
            }
        }

        override func setup() {
            super.setup()

            //backgroundColor = isEditing ? .green : .red

            label.font = font
            label.textColor = textColor
            label.text = "some text"
            label.translatesAutoresizingMaskIntoConstraints = false
            label.adjustsFontSizeToFitWidth = false
            label.numberOfLines = 0
            addSubview(label)
        }

        override func setupSizes() {
            super.setupSizes()

            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true

            label.setContentHuggingPriority(.required, for: .horizontal)
            label.setContentCompressionResistancePriority(.required, for: .horizontal)

            label.setContentHuggingPriority(.required, for: .vertical)
            label.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }
}
