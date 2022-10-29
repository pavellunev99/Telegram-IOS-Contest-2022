//
//  OnDrawAnimatedView.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 24.10.2022.
//

import UIKit

class OnDrawAnimatedView: View {
    private var completion: (() -> Void)?
    private var displayLink: CADisplayLink?
    private var startTs: TimeInterval?
    private var duration: TimeInterval = 0
    var animationProgress: Double = 0

    var animating: Bool {
        return displayLink != nil
    }

    func animate(duration: TimeInterval, completion: @escaping () -> Void) {
        self.completion = completion
        self.duration = duration
        animate()
    }

    func stopAnimation() {
        removeLink()
        completion = nil
    }

    override func removeFromSuperview() {
        removeLink()
        super.removeFromSuperview()
    }

    private func animate() {

        startTs = SystemUptime.uptime()
        animationProgress = 0

        addLink()
    }

    private func addLink() {
        if displayLink == nil {
            displayLink = CADisplayLink.init(target: self, selector: #selector(displayLinkAction))
            displayLink?.add(to: RunLoop.main, forMode: .common)
        }
    }

    private func removeLink() {
        if displayLink != nil {
            displayLink!.remove(from: RunLoop.main, forMode: .common)
            displayLink = nil
        }
    }

    @objc private func displayLinkAction() {
        var shouldStop = true
        if let startTs = startTs, duration > 0 {
            let ts = SystemUptime.uptime()
            var progress = (ts - startTs)/duration
            progress = progress > 1 ? 1 : progress
            progress = progress < 0 ? 0 : progress

            animationProgress = progress
            setNeedsDisplay()

            shouldStop = animationProgress >= 1

        }
        if shouldStop {
            removeLink()
            if let completion = completion {
                self.completion = nil
                completion()
            }
        }
    }
}
