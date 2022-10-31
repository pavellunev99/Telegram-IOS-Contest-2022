//
//  StyledTextView.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 30.10.2022.
//

import UIKit

class StyledTextView: View {

    private let textView = UITextView()

    private var _leading: NSLayoutConstraint?
    private var _trailing: NSLayoutConstraint?
    private var _top: NSLayoutConstraint?
    private var _botom: NSLayoutConstraint?

    private let _strokeWidth: CGFloat = 10

    var textStyle: TextStyle? {
        didSet {
            setNeedsDisplay()
        }
    }

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

    var toolBar: UIView? {
        didSet {
            //textView.inputAccessoryView = toolBar
        }
    }

    var textAlignment: NSTextAlignment? {
        didSet {
            textView.textAlignment = textAlignment ?? .left
        }
    }

    override func becomeFirstResponder() -> Bool {
        textView.becomeFirstResponder()
    }

    override func setup() {
        super.setup()

        backgroundColor = .clear

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = text
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.autocorrectionType = .no
        addSubview(textView)

        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTap))
        bar.items = [done]
        bar.sizeToFit()
        textView.inputAccessoryView = bar
    }

    @objc
    private func doneTap() {
        textView.resignFirstResponder()
    }

    override func setupSizes() {
        super.setupSizes()

        _leading = textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: _strokeWidth)
        _trailing = textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -_strokeWidth)
        _top = textView.topAnchor.constraint(equalTo: topAnchor, constant: _strokeWidth)
        _botom = textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -_strokeWidth)

        _leading?.isActive = true
        _trailing?.isActive = true
        _top?.isActive = true
        _botom?.isActive = true
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext()
        else {
            return
        }

        context.clear(rect)
        context.saveGState()

        context.setLineWidth(_strokeWidth);
        context.setLineJoin(.round)

        context.setTextDrawingMode(.stroke)

        let originalColor = textView.textColor
        textView.textColor = .black
        context.setBlendMode(.copy)
        textView.draw(rect)//drawText(in: rect)
        context.setBlendMode(.normal)

        context.translateBy(x: rect.minX, y: rect.height)
        context.scaleBy(x: 1.0, y: -1.0)

        context.restoreGState()

        textView.textColor = originalColor
        textView.draw(rect)//drawText(in: rect)
    }
}
