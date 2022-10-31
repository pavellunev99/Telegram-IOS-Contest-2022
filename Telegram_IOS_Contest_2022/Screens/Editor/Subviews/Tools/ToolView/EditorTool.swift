//
//  EditorTool.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 24.10.2022.
//

import Foundation

struct EditorTool {

    enum ToolType {
        case pen
        case brush
        case neon
        case pencil
        case lasso
        case eraser
    }

    let toolType: ToolType
}
