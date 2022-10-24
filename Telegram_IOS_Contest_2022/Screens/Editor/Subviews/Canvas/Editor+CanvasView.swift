//
//  Editor+CanvasView.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 13.10.2022.
//

import UIKit

final class EditorCanvasView: View {

    var asset: UIImage? {
        didSet {
            assetImageView.image = asset
            drawView.canvasSize = asset?.size ?? .zero
        }
    }

    private let scrollView = TouchesScrollView()
    private let containerView = UIView()

    private let assetImageView = UIImageView()
    private let drawView = DrawView()
    private let textsView = EditorTextsView()

    override func setup() {
        super.setup()

        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        scrollView.touchesDelegate = drawView

        scrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.isUserInteractionEnabled = false

        containerView.addSubview(assetImageView)
        assetImageView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(drawView)
        drawView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setupSizes() {
        super.setupSizes()

        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true

        assetImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        assetImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        assetImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        assetImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true

        drawView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        drawView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        drawView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        drawView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);

        scrollView.maximumZoomScale = 10
        scrollView.minimumZoomScale = 0.1;
        //scrollView.zoomScale = 10;

        centerScrollViewContents()
    }

    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = containerView.frame

        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0

//        if contentsFrame.size.width < boundsSize.width {
//            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
//        } else {
//            contentsFrame.origin.x = 0.0
//        }
//
//        if contentsFrame.size.height < boundsSize.height {
//            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
//        } else {
//            contentsFrame.origin.y = 0.0
//        }

        containerView.frame = contentsFrame
    }

    func clearAll() {
        drawView.clear()
        textsView.clear()
    }

    func getImageForExport() -> UIImage? {
        assetImageView.image?.compositeWith(image: drawView.image!)
    }
}

extension EditorCanvasView: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        containerView
    }
}
