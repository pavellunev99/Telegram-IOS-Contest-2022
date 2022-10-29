//
//  Tools+TextPropertiesSelector.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 30.10.2022.
//

import UIKit

protocol TextPropertiesSelectorViewDelegate: AnyObject {
    func textAlignmentDidSelected(_ alignment: NSTextAlignment)
    func textFontDidSelected(_ font: UIFont)
}

fileprivate protocol AlignmentSelectorViewDelegate: AnyObject {
    func textAlignmentDidSelected(_ alignment: NSTextAlignment)
}

fileprivate protocol FontSelectorViewDelegate: AnyObject {
    func textFontDidSelected(_ font: UIFont)
}

extension EditorToolsView {

    final class TextPropertiesSelectorView: View,
                                            AlignmentSelectorViewDelegate,
                                            FontSelectorViewDelegate {

        weak var delegate: TextPropertiesSelectorViewDelegate?

        fileprivate let alignmentView = AlignmentSelectorView()
        fileprivate let fontsView = FontSelectorView()

        override func setup() {
            super.setup()

            alignmentView.translatesAutoresizingMaskIntoConstraints = false
            alignmentView.delegate = self
            addSubview(alignmentView)

            fontsView.translatesAutoresizingMaskIntoConstraints = false
            fontsView.delegate = self
            addSubview(fontsView)
        }

        override func setupSizes() {
            super.setupSizes()

            heightAnchor.constraint(equalToConstant: 30).isActive = true

            alignmentView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            alignmentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            alignmentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            alignmentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

            fontsView.leadingAnchor.constraint(equalTo: alignmentView.trailingAnchor).isActive = true
            fontsView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            fontsView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            fontsView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }

        func textAlignmentDidSelected(_ alignment: NSTextAlignment) {
            delegate?.textAlignmentDidSelected(alignment)
        }

        func textFontDidSelected(_ font: UIFont) {
            delegate?.textFontDidSelected(font)
        }
    }

    fileprivate final class AlignmentSelectorView: View {

        private let _availableAlignments: [NSTextAlignment] = [.left, .center, .right]

        private var _selectedAlignment: NSTextAlignment = .left {
            didSet {
                _update()
                delegate?.textAlignmentDidSelected(_selectedAlignment)
            }
        }

        weak var delegate: AlignmentSelectorViewDelegate?

        private let imageView = UIImageView()

        override func setup() {
            super.setup()

            addTarget(self, action: #selector(_tapAction), for: .touchUpInside)

            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isUserInteractionEnabled = false
            addSubview(imageView)

            _update()
        }

        override func setupSizes() {
            super.setupSizes()

            imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }

        private func _update() {
            switch _selectedAlignment {
            case .left:
                imageView.image = .init(named: "textLeft")
            case .center:
                imageView.image = .init(named: "textCenter")
            case .right:
                imageView.image = .init(named: "textRight")
            default:
                break
            }
        }

        @objc
        private func _tapAction() {
            let nextAlignment: NSTextAlignment

            if let index = _availableAlignments.firstIndex(of: _selectedAlignment) {

                if index + 1 >= _availableAlignments.count {
                    nextAlignment = _availableAlignments.first!
                } else {
                    nextAlignment = _availableAlignments[index + 1]
                }

            } else {
                nextAlignment = _availableAlignments.first!
            }

            self._selectedAlignment = nextAlignment
        }
    }

    fileprivate final class FontSelectorView: View {

        weak var delegate: FontSelectorViewDelegate?

        override func setup() {
            super.setup()

        }

        override func setupSizes() {
            super.setupSizes()
        }
    }
}
