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
}

class TouchesScrollView: UIScrollView {

    weak var touchesDelegate: ScrollViewTouchesDelegate?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if self.isZooming == true {
            self.next?.touchesBegan(touches, with: event)
        } else {
            super.touchesBegan(touches, with: event)
            touchesDelegate?.scrollViewTouchesBegan(touches, with: event)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if self.isZooming == true {
            self.next?.touchesMoved(touches, with: event)
        } else {
            super.touchesMoved(touches, with: event)
            touchesDelegate?.scrollViewTouchesMoved(touches, with: event)
        }
    }
}
