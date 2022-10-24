//
//  EditorViewController.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import UIKit
import Photos

final class EditorViewController: ViewController {

    var asset: PHAsset

    let navigationView = EditorNavigationView()
    let canvasView = EditorCanvasView()
    let toolsView = EditorToolsView()

    let gradientLayer = CAGradientLayer()

    init(asset: PHAsset) {
        self.asset = asset
        
        super.init(nibName: nil, bundle: nil)

        let options = PHImageRequestOptions()
        options.version = .original

        PHImageManager.default().requestImage(for: asset, targetSize: .zero, contentMode: .aspectFit, options: options) { [weak self] image, _ in
            self?.canvasView.asset = image
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()

        view.backgroundColor = .black

        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.layer.mask = gradientLayer
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.5).cgColor,
                                UIColor.black.cgColor,
                                UIColor.black.cgColor,
                                UIColor.black.withAlphaComponent(0.5).cgColor]
        gradientLayer.locations =  [0.0, 0.15, 0.85, 1.0]
        view.addSubview(canvasView)

        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.delegate = self
        view.addSubview(navigationView)

        // TODO
        navigationView.cancelButton.isHidden = true
        navigationView.doneButton.isHidden = true
        //

        toolsView.translatesAutoresizingMaskIntoConstraints = false
        toolsView.delegate = self
        view.addSubview(toolsView)
    }

    override func setupSizes() {
        super.setupSizes()

        navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        canvasView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        toolsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = canvasView.frame
    }
}
