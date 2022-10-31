//
//  Editor+DrawView.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 13.10.2022.
//

import UIKit

extension EditorCanvasView {

    final class DrawView: View {

        let canvas = Canvas(frame: .init(origin: .zero, size: .init(width: 100, height: 100)))
        var brushes: [Brush] = []

        override func setup() {
            super.setup()

            canvas.translatesAutoresizingMaskIntoConstraints = false
            canvas.backgroundColor = .clear
            canvas.data.addObserver(self)
            addSubview(canvas)

            registerBrushes()
        }

        override func setupSizes() {
            super.setupSizes()

            canvas.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            canvas.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            canvas.topAnchor.constraint(equalTo: topAnchor).isActive = true
            canvas.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            canvas.frame = bounds
        }

        private func registerBrushes() {
            do {
                let pen = canvas.defaultBrush!
                pen.name = "Pen"
                pen.pointSize = 5
                pen.pointStep = 0.5
                pen.color = .red

                let pencil = try registerBrush(with: "pencil-texture")
                pencil.rotation = .random
                pencil.pointSize = 3
                pencil.pointStep = 2
                pencil.forceSensitive = 0.3
                pencil.opacity = 1

                let brush = try registerBrush(with: "brush-texture")
                brush.opacity = 1
                brush.rotation = .ahead
                brush.pointSize = 15
                brush.pointStep = 1
                brush.forceSensitive = 1
                brush.color = .red
                brush.forceOnTap = 0.5

                let texture = try canvas.makeTexture(with: UIImage(named: "glow-texture")!.pngData()!)
                let glow: GlowingBrush = try canvas.registerBrush(name: "glow", textureID: texture.id)
                glow.opacity = 0.5
                glow.coreProportion = 0.2
                glow.pointSize = 20
                glow.rotation = .ahead

                let eraser = try! canvas.registerBrush(name: "Eraser") as Eraser
                eraser.opacity = 1

                brushes = [pen, pencil, brush, glow, eraser]

                brush.use()

            } catch {
                print(error.localizedDescription)
            }
        }

        private func registerBrush(with imageName: String) throws -> Brush {
            let texture = try canvas.makeTexture(with: UIImage(named: imageName)!.pngData()!)
            return try canvas.registerBrush(name: imageName, textureID: texture.id)
        }

        func selectTool(_ tool: EditorTool) {
            switch tool.toolType {
            case .pen:
                brushes[0].use()
            case .brush:
                brushes[2].use()
            case .neon:
                brushes[3].use()
            case .pencil:
                brushes[1].use()
            case .lasso:
                break
            case .eraser:
                brushes[5].use()
            }
        }

        func selectColor(_ color: UIColor) {
            canvas.currentBrush.color = color
        }

        func clear() {
            canvas.clear()
        }

        func getImage() -> UIImage? {
            canvas.snapshot()
        }
    }
}

extension EditorCanvasView.DrawView: ScrollViewTouchesDelegate {

    func scrollViewTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        canvas.touchesBegan(touches, with: event)
    }

    func scrollViewTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        canvas.touchesMoved(touches, with: event)
    }

    func scrollViewTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canvas.touchesEnded(touches, with: event)
    }
}

extension EditorCanvasView.DrawView: DataObserver {

    func lineStrip(_ strip: LineStrip, didBeginOn data: CanvasData) {
    }

    func element(_ element: CanvasElement, didFinishOn data: CanvasData) {
    }

    func dataDidClear(_ data: CanvasData) {
    }

    func dataDidUndo(_ data: CanvasData) {
    }

    func dataDidRedo(_ data: CanvasData) {
    }
}
