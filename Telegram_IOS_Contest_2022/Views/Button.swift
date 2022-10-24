//
//  CircleButton.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 15.10.2022.
//

import UIKit

class Button: View {

    let imageView = UIImageView()

    override func setup() {
        super.setup()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        addSubview(imageView)
    }

    override func setupSizes() {
        super.setupSizes()

        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

class TextButton: View {

    let label = UILabel()

    override func setup() {
        super.setup()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        addSubview(label)
    }

    override func setupSizes() {
        super.setupSizes()

        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

class CircleButton: Button {

    let backgroundView = UIView()

    override func setup() {

        layer.masksToBounds = true

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.isUserInteractionEnabled = false
        addSubview(backgroundView)

        super.setup()
    }

    override func setupSizes() {

        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        super.setupSizes()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
}
