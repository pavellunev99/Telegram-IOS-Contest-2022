//
//  EditorViewController.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import UIKit
import Photos

final class EditorViewController: ViewController {

    var asset: PHAsset? {
        didSet {
            _requestImage()
        }
    }

    let navigationView = EditorNavigationView()
    let canvasView = EditorCanvasView()
    let toolsView = EditorToolsView()
    let activityIndicator = UIActivityIndicatorView(style: .medium)

    let gradientLayer = CAGradientLayer()

    let colorSelectorViewController = ColorSelectorViewController()

    // MARK: Properties

    var drawColor: UIColor = .red

    var textFont: UIFont = .systemFont(ofSize: 100, weight: .bold)
    var textColor: UIColor = .white
    var textAlignment: NSTextAlignment = .left
    var textStyle: TextStyle = .none

    override func setup() {
        super.setup()

        view.backgroundColor = .black

        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.layer.mask = gradientLayer
        canvasView.drawView.delegate = self
        canvasView.textsView.delegate = self

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
        toolsView.centerView.textsSelectors.delegate = self
        view.addSubview(toolsView)

        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        view.addSubview(activityIndicator)

        colorSelectorViewController.modalPresentationStyle = .formSheet
        colorSelectorViewController.delegate = self

        if let sheet = colorSelectorViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = false
            sheet.prefersEdgeAttachedInCompactHeight = true
        }

        centerViewDrawEditorSelected()
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

        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = canvasView.frame
    }

    private func _requestImage() {
        guard let asset = asset else { return }

        let options = PHImageRequestOptions()
        options.version = .original
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat

        activityIndicator.startAnimating()

        PHImageManager.default().requestImage(for: asset, targetSize: .zero, contentMode: .aspectFit, options: options) { [weak self] image, _ in
            self?.activityIndicator.stopAnimating()
            self?.canvasView.asset = image
        }
    }
}
