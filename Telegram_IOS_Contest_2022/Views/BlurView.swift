//
//  BlurView.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 23.10.2022.
//

import UIKit

final class BlurView: View {

    var style: UIBlurEffect.Style = .light {
        didSet {
            effectView.effect = UIBlurEffect(style: style)
        }
    }

    private let effectView = UIVisualEffectView()

    override func setup() {
        super.setup()

        effectView.effect = UIBlurEffect(style: style)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(effectView)
    }

    override func setupSizes() {
        super.setupSizes()

        effectView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        effectView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        effectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        effectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
