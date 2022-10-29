//
//  Weak.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 29.10.2022.
//

import Foundation

class Weak<T: AnyObject> {
  weak var value : T?
  init (value: T) {
    self.value = value
  }
}

extension Array where Element:Weak<AnyObject> {
  mutating func reap () {
    self = self.filter { nil != $0.value }
  }
}
