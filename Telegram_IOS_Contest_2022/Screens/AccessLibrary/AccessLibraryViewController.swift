//
//  AccessLibraryViewController.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import UIKit
import Photos

final class AccessLibraryViewController: ViewController {

    private let button = RoundedButton()

    var onComplete: ((PHAuthorizationStatus) -> Void)?

    override func setup() {
        super.setup()

        view.backgroundColor = .black

        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.text = "Allow Access"
        button.addTarget(self, action: #selector(tapRequestAccess), for: .touchUpInside)
    }

    override func setupSizes() {
        super.setupSizes()

        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    }

    @objc
    func tapRequestAccess() {
        PhotosService.shared.requestAccess { [weak self] status in
            self?.onComplete?(status)
        }
    }
}
