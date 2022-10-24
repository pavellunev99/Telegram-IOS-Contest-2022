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
}
