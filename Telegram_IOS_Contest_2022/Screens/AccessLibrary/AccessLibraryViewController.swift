//
//  AccessLibraryViewController.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import UIKit
import Photos

final class AccessLibraryViewController: ViewController {

    private let containerView = UIView()
    private let imageView = UIImageView()
    private let label = UILabel()
    private let button = RoundedButton()

    var onComplete: ((PHAuthorizationStatus) -> Void)?

    override func setup() {
        super.setup()

        view.backgroundColor = .black

        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        imageView.image = .init(named: "accessLibrary")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)

        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.text = "Access Your Photos and Videos"
        label.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.text = "Allow Access"
        button.addTarget(self, action: #selector(tapRequestAccess), for: .touchUpInside)
        containerView.addSubview(button)

        button.startSparkling()
    }

    override func setupSizes() {
        super.setupSizes()

        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        imageView.widthAnchor.constraint(equalToConstant: 144).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 144).isActive = true
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true

        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true

        button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 28).isActive = true
        button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        button.stopSparkling()
    }

    @objc
    func tapRequestAccess() {
        PhotosService.shared.requestAccess { [weak self] status in
            self?.onComplete?(status)
        }
    }
}
