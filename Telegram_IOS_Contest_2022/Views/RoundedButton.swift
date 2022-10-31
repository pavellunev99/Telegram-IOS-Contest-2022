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
    private let sparkView = SparkView()
    private var sparkTimer: Timer?

    override func setup() {
        backgroundColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        layer.masksToBounds = true
        layer.cornerRadius = 10

        sparkView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sparkView)

        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
    }

    override func setupSizes() {
        sparkView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sparkView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sparkView.trailingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        sparkView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 3).isActive = true

        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -4).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
    }

    func startSparkling() {
        sparkTimer = .scheduledTimer(timeInterval: 3,
                                     target: self,
                                     selector: #selector(_showSpark),
                                     userInfo: nil,
                                     repeats: true)
    }

    func stopSparkling() {
        sparkTimer?.invalidate()
        sparkTimer = nil
    }

    @objc
    private func _showSpark() {
        UIView.animate(withDuration: 1, delay: 0, options: []) {
            self.sparkView.transform = .identity
                .translatedBy(x: self.frame.width + self.sparkView.frame.width, y: 0)
        } completion: { _ in
            self.sparkView.transform = .identity
        }
    }
}

extension RoundedButton {

    final class SparkView: View {

        let gradientLayer = CAGradientLayer()

        override func setup() {
            super.setup()

            backgroundColor = .white
            alpha = 0.5

            gradientLayer.colors = [UIColor.clear.cgColor,
                                    UIColor.black.withAlphaComponent(0.5).cgColor,
                                    UIColor.clear.cgColor]
            gradientLayer.locations =  [0.0, 0.5, 1.0]
            gradientLayer.startPoint = .init(x: 0, y: 0.5)
            gradientLayer.endPoint = .init(x: 1, y: 0.5)

            layer.mask = gradientLayer
        }

        override func setupSizes() {
            super.setupSizes()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            gradientLayer.frame = bounds
        }
    }
}
