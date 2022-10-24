//
//  EditorViewController+NavigationView.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 23.10.2022.
//

import UIKit

protocol EditorNavigationViewDelegate: AnyObject {
    func navigationViewTapCancel()
    func navigationViewTapDone()
    func navigationViewTapClearAll()
    func navigationViewTapUndo()
    func navigationViewTapZoomOut()
}

extension EditorViewController {

    final class EditorNavigationView: View {

        weak var delegate: EditorNavigationViewDelegate?

        let cancelButton = TextButton()
        let doneButton = TextButton()
        let clearAllButton = TextButton()
        let undoButton = Button()
        let zoomOutButton = ZooomOutButton()

        override func setup() {
            super.setup()

            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
            cancelButton.label.textColor = .white
            cancelButton.label.font = .systemFont(ofSize: 17, weight: .regular)
            cancelButton.label.text = "Cancel"
            addSubview(cancelButton)

            doneButton.translatesAutoresizingMaskIntoConstraints = false
            doneButton.addTarget(self, action: #selector(tapDone), for: .touchUpInside)
            doneButton.label.textColor = .white
            doneButton.label.font = .systemFont(ofSize: 17, weight: .semibold)
            doneButton.label.text = "Done"
            addSubview(doneButton)

            clearAllButton.translatesAutoresizingMaskIntoConstraints = false
            clearAllButton.addTarget(self, action: #selector(tapClearAll), for: .touchUpInside)
            clearAllButton.label.textColor = .white
            clearAllButton.label.font = .systemFont(ofSize: 17, weight: .regular)
            clearAllButton.label.text = "Clear All"
            addSubview(clearAllButton)

            undoButton.translatesAutoresizingMaskIntoConstraints = false
            undoButton.addTarget(self, action: #selector(tapUndo), for: .touchUpInside)
            undoButton.imageView.image = .init(named: "undo")
            undoButton.imageView.contentMode = .scaleToFill
            addSubview(undoButton)

            zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
            zoomOutButton.addTarget(self, action: #selector(tapZoomOut), for: .touchUpInside)
            addSubview(zoomOutButton)
        }

        override func setupSizes() {
            super.setupSizes()

            // leading

            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
            cancelButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

            undoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
            undoButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
            undoButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            undoButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
            undoButton.widthAnchor.constraint(equalToConstant: 24).isActive = true

            // trailing

            clearAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
            clearAllButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
            clearAllButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
            doneButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
            doneButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

            // center

            zoomOutButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            zoomOutButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
            zoomOutButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }

        @objc
        private func tapCancel() {
            delegate?.navigationViewTapCancel()
        }

        @objc
        private func tapDone() {
            delegate?.navigationViewTapDone()
        }

        @objc
        private func tapClearAll() {
            delegate?.navigationViewTapClearAll()
        }

        @objc
        private func tapUndo() {
            delegate?.navigationViewTapUndo()
        }

        @objc
        private func tapZoomOut() {
            delegate?.navigationViewTapZoomOut()
        }
    }

    class ZooomOutButton: View {

        override func setup() {
            super.setup()
        }

        override func setupSizes() {
            super.setupSizes()
        }
    }
}
