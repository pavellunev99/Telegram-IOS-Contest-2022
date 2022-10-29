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
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

    func toolsViewTapClose() {
        dismiss(animated: true)
    }

    func toolsViewTapSelectColor() {
        switch Int.random(in: 0...5) {
        case 0:
            drawColor = .cyan
        case 1:
            drawColor = .green
        case 2:
            drawColor = .blue
        case 3:
            drawColor = .white
        case 4:
            drawColor = .yellow
        default:
            drawColor = .red
        }
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
    }

    func textFontDidSelected(_ font: UIFont) {
        self.textFont = font
    }

}
