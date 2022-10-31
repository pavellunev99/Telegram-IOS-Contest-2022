//
//  EditorViewController+CanvasDelegates.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 29.10.2022.
//

import UIKit

extension EditorViewController: EditorDrawViewPropertiesDelegate {

    func selectedColor() -> UIColor {
        drawColor
    }
}

extension EditorViewController: EditorTextsViewDelegate {

    func editorTextsViewFont() -> UIFont {
        textFont
    }

    func editorTextsViewColor() -> UIColor {
        textColor
    }

    func editorTextsViewAlignment() -> NSTextAlignment {
        textAlignment
    }

    func editorTextStyle() -> TextStyle {
        textStyle
    }

    func editorKeyboardToolBar() -> UIView {
        toolsView.centerView.textsSelectors
    }
}
