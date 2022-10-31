//
//  EditorViewController+ToolsDelegate.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 23.10.2022.
//

import UIKit

extension EditorViewController: EditorToolsViewDelegate {

    func toolsViewTapSave() {
        guard let image = canvasView.getImageForExport() else { return }
        activityIndicator.startAnimating()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        activityIndicator.stopAnimating()

        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            dismiss(animated: true)
        }
    }

    func toolsViewTapClose() {
        dismiss(animated: true)
    }

    func toolsViewTapSelectColor() {
        present(colorSelectorViewController, animated: true)
    }

    func centerViewDrawEditorSelected() {
        canvasView.enableDrawEditor()
    }

    func centerViewTextEditorSelected() {
        canvasView.enableTextEditor()
    }
}

extension EditorViewController: TextPropertiesSelectorViewDelegate {

    func textAlignmentDidSelected(_ alignment: NSTextAlignment) {
        self.textAlignment = alignment
        canvasView.textsView.updateEditingViewStyle()
    }

    func textFontFamilyDidSelected(_ family: String) {
        let fontNames = UIFont.fontNames(forFamilyName: family)
        let fontName: String

        if let boldFontName = fontNames.first(where: { $0.contains("Bold") }) {
            fontName = boldFontName
        } else {
            fontName = fontNames.first!
        }

        self.textFont = UIFont.init(name: fontName, size: 100) ?? .systemFont(ofSize: 100)

        canvasView.textsView.updateEditingViewStyle()
    }

    func textStyleDidSelected(_ style: TextStyle) {
        self.textStyle = style
        canvasView.textsView.updateEditingViewStyle()
    }
}
