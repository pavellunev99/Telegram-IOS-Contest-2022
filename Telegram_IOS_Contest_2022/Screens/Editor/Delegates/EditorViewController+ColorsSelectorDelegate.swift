//
//  EditorViewController+ColorsSelectorDelegate.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 31.10.2022.
//

import UIKit

extension EditorViewController: ColorSelectorViewDelegate {

    func colorSelectorViewTapPipette() {
        colorSelectorViewController.dismiss(animated: true)
    }

    func colorSelectorDidSelectColor(_ color: UIColor) {
        drawColor = color
    }
}
