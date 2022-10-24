//
//  View.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import UIKit

class View: UIControl {

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard frame != .zero else { return }
        setupSizes()
    }

    func setup() {

    }

    func setupSizes() {

    }
}
