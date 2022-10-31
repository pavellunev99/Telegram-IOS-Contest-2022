//
//  MLError.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import Foundation

enum MLError: Error {
    case initializationError
    case fileNotExists(String)
    case imageNotExists(String)
    case convertPNGDataFailed
    case fileDamaged
    case directoryNotEmpty(URL)
    case simulatorUnsupported
}
