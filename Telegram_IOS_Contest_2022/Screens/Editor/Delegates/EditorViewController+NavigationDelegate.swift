//
//  EditorViewController+NavigationDelegate.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 23.10.2022.
//

import UIKit

extension EditorViewController: EditorNavigationViewDelegate {

    func navigationViewTapCancel() {

    }

    func navigationViewTapDone() {

    }

    func navigationViewTapClearAll() {
        canvasView.clearAll()
    }

    func navigationViewTapUndo() {
        canvasView.drawView.undo()
    }

    func navigationViewTapZoomOut() {

    }
}
