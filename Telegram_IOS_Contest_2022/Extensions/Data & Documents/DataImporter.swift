//
//  DataImporter.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 09.10.2022.
//

import Foundation

class DataImporter {

    static func importData(from directory: URL, to canvas: Canvas, progress: ProgressHandler? = nil, result: ResultHandler? = nil) {
        DispatchQueue(label: "com.importing").async {
            do {
                try self.importDataSynchronously(from: directory, to: canvas, progress: progress)
                DispatchQueue.main.async {
                    result?(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    result?(.failure(error))
                }
            }
        }
    }
    
    static func importDataSynchronously(from directory: URL, to canvas: Canvas, progress: ProgressHandler? = nil) throws {
        
        let decoder = JSONDecoder()

        let infoData = try Data(contentsOf: directory.appendingPathComponent("info"))
        let info = try decoder.decode(DocumentInfo.self, from: infoData)
        guard info.library != nil else {
            throw MLError.fileDamaged
        }
        reportProgress(0.02, on: progress)

        let contentData = try Data(contentsOf: directory.appendingPathComponent("content"))
        let content = try decoder.decode(CanvasContent.self, from: contentData)
        reportProgress(0.1, on: progress)

        do {
            let texturePaths = try FileManager.default.contentsOfDirectory(at: directory.appendingPathComponent("textures"), includingPropertiesForKeys: [], options: [])
            reportProgress(0.15, on: progress)
            for i in 0 ..< texturePaths.count {
                let path = texturePaths[i]
                let data = try Data(contentsOf: path)
                try canvas.makeTexture(with: data, id: path.lastPathComponent)
                reportProgress(base: 0.15, unit: i, total: texturePaths.count, on: progress)
            }
        } catch {
            if info.chartlets > 0 {
                throw MLError.fileDamaged
            }
        }

        content.lineStrips.forEach { $0.brush = canvas.findBrushBy(name: $0.brushName) ?? canvas.defaultBrush }
        content.chartlets.forEach { $0.canvas = canvas }
        canvas.data.elements = (content.lineStrips + content.chartlets).sorted(by: { $0.index < $1.index})
        reportProgress(1, on: progress)

        DispatchQueue.main.async {
            canvas.redraw()
        }
    }
}
