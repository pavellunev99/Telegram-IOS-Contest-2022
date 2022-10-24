//
//  RoundedButton.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import UIKit

class RoundedButton: View {

    var text: String? {
        didSet {
            label.text = text
        }
    }

    let label = UILabel()

    override func setup() {
        backgroundColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        layer.masksToBounds = true
        layer.cornerRadius = 10

        addSubview(label)
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setupSizes() {
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -4).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
    }
}
