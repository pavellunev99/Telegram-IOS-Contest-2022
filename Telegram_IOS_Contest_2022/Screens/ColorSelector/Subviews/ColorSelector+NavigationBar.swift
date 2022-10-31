//
//  ColorSelector+NavigationBar.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 31.10.2022.
//

import UIKit

protocol ColorSelectorNavigationViewDelegate: AnyObject {
    func navigationViewTapClose()
    func navigationViewTapPipette()
}

extension ColorSelectorViewController {

    final class NavigationBar: View {

        weak var delegate: ColorSelectorNavigationViewDelegate?

        let pipetteButton = Button()
        let closeButton = Button()
        let title = UILabel()

        override func setup() {
            super.setup()

            pipetteButton.imageView.image = UIImage(systemName: "eyedropper")?.withRenderingMode(.alwaysTemplate)
            pipetteButton.imageView.tintColor = .white
            pipetteButton.translatesAutoresizingMaskIntoConstraints = false
            pipetteButton.addTarget(self, action: #selector(tapPipette), for: .touchUpInside)
            addSubview(pipetteButton)

            title.text = "Colors"
            title.translatesAutoresizingMaskIntoConstraints = false
            title.textColor = .white
            title.font = .systemFont(ofSize: 17, weight: .semibold)
            addSubview(title)

            closeButton.imageView.image = .init(named: "cancel")
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            closeButton.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
            addSubview(closeButton)
        }

        override func setupSizes() {
            super.setupSizes()

            pipetteButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            pipetteButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
            pipetteButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

            pipetteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            pipetteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true

            title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            closeButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
            closeButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

            closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        }

        @objc
        private func tapPipette() {
            delegate?.navigationViewTapPipette()
        }

        @objc
        private func tapClose() {
            delegate?.navigationViewTapClose()
        }
    }
}
