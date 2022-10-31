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
    func editorTextStyle() -> TextStyle
    func editorKeyboardToolBar() -> UIView
}

extension EditorCanvasView {

    final class TextsView: View {

        weak var delegate: EditorTextsViewDelegate?

        private weak var editingView: TextItemView? {
            didSet {
                let _ = editingView?.becomeFirstResponder()
                _updateEditingViewState()
            }
        }

        func updateEditingViewStyle() {
            if let editingView = editingView {
                editingView.font = delegate?.editorTextsViewFont()
                editingView.textColor = delegate?.editorTextsViewColor()
                editingView.textAlignment = delegate?.editorTextsViewAlignment()
                editingView.textStyle = delegate?.editorTextStyle()
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
            textView.textStyle = delegate?.editorTextStyle()
            //textView.toolBar = delegate?.editorKeyboardToolBar()

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

extension EditorCanvasView.TextsView {

    fileprivate final class TextItemView: View {

        private let textView = StyledTextView()

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
                textView.font = font
            }
        }

        var textColor: UIColor? {
            didSet {
                textView.textColor = textColor
            }
        }

        var text: String? {
            get {
                textView.text
            }

            set {
                textView.text = newValue
            }
        }

        var textStyle: TextStyle? {
            didSet {
                textView.textStyle = textStyle
            }
        }

        var textAlignment: NSTextAlignment? {
            didSet {
                textView.textAlignment = textAlignment
            }
        }

        var toolBar: UIView? {
            didSet {
                textView.toolBar = toolBar
            }
        }

        var isEditing: Bool = false {
            didSet {

            }
        }

        override func setup() {
            super.setup()

            textView.font = font
            textView.textColor = textColor
            textView.text = "some text"
            textView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(textView)
        }

        override func setupSizes() {
            super.setupSizes()

            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true

            textView.setContentHuggingPriority(.required, for: .horizontal)
            textView.setContentCompressionResistancePriority(.required, for: .horizontal)

            textView.setContentHuggingPriority(.required, for: .vertical)
            textView.setContentCompressionResistancePriority(.required, for: .vertical)
        }

        override func becomeFirstResponder() -> Bool {
            textView.becomeFirstResponder()
        }
    }
}
