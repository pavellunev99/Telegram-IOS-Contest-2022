//
//  Tools+TextPropertiesSelector.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 30.10.2022.
//

import UIKit

enum TextStyle {
    case none
    case filled
    case semi
    case stroke
}

protocol TextPropertiesSelectorViewDelegate: AnyObject {
    func textAlignmentDidSelected(_ alignment: NSTextAlignment)
    func textFontFamilyDidSelected(_ family: String)
    func textStyleDidSelected(_ style: TextStyle)
}

fileprivate protocol StyleSelectorViewDelegate: AnyObject {
    func textStyleDidSelected(_ style: TextStyle)
}

fileprivate protocol AlignmentSelectorViewDelegate: AnyObject {
    func textAlignmentDidSelected(_ alignment: NSTextAlignment)
}

fileprivate protocol FontFamilySelectorViewDelegate: AnyObject {
    func textFontFamilyDidSelected(_ family: String)
}

extension EditorToolsView {

    final class TextPropertiesSelectorView: View,
                                            StyleSelectorViewDelegate,
                                            AlignmentSelectorViewDelegate,
                                            FontFamilySelectorViewDelegate {

        weak var delegate: TextPropertiesSelectorViewDelegate?

        fileprivate let styleView = StyleSelectorView()
        fileprivate let alignmentView = AlignmentSelectorView()
        fileprivate let fontsView = FontFamilySelectorView()

        override func setup() {
            super.setup()

            styleView.translatesAutoresizingMaskIntoConstraints = false
            styleView.delegate = self
            addSubview(styleView)

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

            styleView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            styleView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            styleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            styleView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

            alignmentView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            alignmentView.leadingAnchor.constraint(equalTo: styleView.trailingAnchor, constant: 16).isActive = true
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

        func textFontFamilyDidSelected(_ family: String) {
            delegate?.textFontFamilyDidSelected(family)
        }

        func textStyleDidSelected(_ style: TextStyle) {
            delegate?.textStyleDidSelected(style)
        }
    }

    fileprivate final class StyleSelectorView: View {

        private let _availableStyles: [TextStyle] = [.none, .filled, .semi, .stroke]

        private var _selectedStyle: TextStyle = .none {
            didSet {
                _update()
                delegate?.textStyleDidSelected(_selectedStyle)
            }
        }

        weak var delegate: StyleSelectorViewDelegate?

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
            switch _selectedStyle {
            case .none:
                imageView.image = .init(named: "default")
            case .filled:
                imageView.image = .init(named: "filled")
            case .semi:
                imageView.image = .init(named: "semi")
            case .stroke:
                imageView.image = .init(named: "stroke")
            }
        }

        @objc
        private func _tapAction() {
            let nextStyle: TextStyle

            if let index = _availableStyles.firstIndex(of: _selectedStyle) {

                if index + 1 >= _availableStyles.count {
                    nextStyle = _availableStyles.first!
                } else {
                    nextStyle = _availableStyles[index + 1]
                }

            } else {
                nextStyle = _availableStyles.first!
            }

            self._selectedStyle = nextStyle
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

    fileprivate final class FontFamilySelectorView: View, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        weak var delegate: FontFamilySelectorViewDelegate?

        private var collectionLayout: UICollectionViewFlowLayout = {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 12
            $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            $0.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
            return $0
        }(UICollectionViewFlowLayout())

        private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)

        override func setup() {
            super.setup()

            collectionView.register(FontFamilyCell.self, forCellWithReuseIdentifier: "cell")
            collectionView.backgroundColor = .clear
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.contentInsetAdjustmentBehavior = .never
            addSubview(collectionView)
        }

        override func setupSizes() {
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FontFamilyCell {

                let fontNames = UIFont.fontNames(forFamilyName: UIFont.familyNames[indexPath.row])
                let fontName: String

                if let boldFontName = fontNames.first(where: { $0.contains("Bold") }) {
                    fontName = boldFontName
                } else {
                    fontName = fontNames.first!
                }

                let font = UIFont.init(name: fontName, size: 13)
                cell.font = font

                return cell
            } else {
                return UICollectionViewCell()
            }
        }

        func numberOfSections(in collectionView: UICollectionView) -> Int {
            1
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            UIFont.familyNames.count
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

            let cell = collectionView.cellForItem(at: indexPath)
            cell?.isSelected = true

            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

            delegate?.textFontFamilyDidSelected(UIFont.familyNames[indexPath.row])
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            .zero
        }
    }

    fileprivate final class FontFamilyCell: UICollectionViewCell {

        override var isSelected: Bool {
            didSet {
                contentView.layer.borderColor = isSelected ? UIColor.white.cgColor : UIColor.white.withAlphaComponent(0.33).cgColor
            }
        }

        var font: UIFont? {
            didSet {
                label.text = font?.familyName
                label.font = font
            }
        }

        let label = UILabel()

        override init(frame: CGRect) {
            super.init(frame: frame)

            contentView.layer.borderWidth = 1
            contentView.layer.masksToBounds = true
            contentView.layer.cornerRadius = 9
            contentView.layer.borderColor = isSelected ? UIColor.white.cgColor : UIColor.white.withAlphaComponent(0.33).cgColor

            label.textAlignment = .center
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(label)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func didMoveToSuperview() {
            super.didMoveToSuperview()

            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
            label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

            label.heightAnchor.constraint(equalToConstant: 30).isActive = true

            label.setContentHuggingPriority(.required, for: .horizontal)
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
    }
}
