//
//  ScrollViewDelegate.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 15.10.2022.
//

import Foundation
import UIKit

protocol ScrollViewTouchesDelegate: AnyObject {
    func scrollViewTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    func scrollViewTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    func scrollViewTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
}

class TouchesScrollView: UIScrollView {

    private var _weakDelegates: [Weak<UIView>] = []

    private var delegates: [ScrollViewTouchesDelegate] {
        _weakDelegates.compactMap({ $0.value as? ScrollViewTouchesDelegate })
    }

    func addDelegate(_ delegate: UIView) {
        guard delegate is ScrollViewTouchesDelegate else { return }
        _weakDelegates.append(.init(value: delegate))
    }

    func removeDelegate(_ delegate: UIView) {
        if let index = _weakDelegates.firstIndex(where: { $0.value == delegate }) {
            _weakDelegates.remove(at: index)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if self.isZooming == true {
            self.next?.touchesBegan(touches, with: event)
        } else {
            super.touchesBegan(touches, with: event)

            delegates.forEach {
                $0.scrollViewTouchesBegan(touches, with: event)
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if self.isZooming == true {
            self.next?.touchesMoved(touches, with: event)
        } else {
            super.touchesMoved(touches, with: event)

            delegates.forEach {
                $0.scrollViewTouchesMoved(touches, with: event)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesEnded(touches, with: event)
        super.touchesEnded(touches, with: event)

        delegates.forEach {
            $0.scrollViewTouchesEnded(touches, with: event)
        }
    }
}
