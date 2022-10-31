//
//  Document.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 13.10.2022.
//

import Foundation
import CoreGraphics

struct DocumentInfo: Codable {
    static let `default` = DocumentInfo()
    var identifier: String?
    let version: String
    let app: BundleInfo?
    let library: BundleInfo?
    var lines: Int = 0
    var chartlets: Int = 0
    var textures: Int = 0

    init(identifier: String? = nil) {
        self.identifier = identifier ?? UUID().uuidString
        library = try? Bundle(for: Canvas.classForCoder()).readInfo()
        app = try? Bundle.main.readInfo()
        version = library?.version ?? "unknown"
    }
}

/// contents' vector data on the canvas
struct CanvasContent: Codable {
    
    /// content size of canvas
    var size: CGSize?
    
    /// all linestrips
    var lineStrips: [LineStrip] = []
    
    /// chatlets
    var chartlets: [Chartlet] = []
    
    init(size: CGSize?, lineStrips: [LineStrip], chartlets: [Chartlet]) {
        self.size = size
        self.lineStrips = lineStrips
        self.chartlets = chartlets
    }
}

/// base infomation for bundle from info.plist
struct BundleInfo: Codable {
    var name: String
    var version: String
    var identifier: String
}

extension Bundle {
    /// read base infomation from info.plist
    func readInfo() throws -> BundleInfo {
        guard let file = url(forResource: "Info", withExtension: "plist") else {
            throw MLError.fileNotExists("Info.plist")
        }
        let data = try Data(contentsOf: file)
        let info = try PropertyListDecoder().decode(__Info.self, from: data)
        return info.makePublic()
    }
    
    private struct __Info: Codable {
        var name: String
        var version: String
        var identifier: String
        
        enum CodingKeys: String, CodingKey {
            case name = "CFBundleName"
            case version = "CFBundleShortVersionString"
            case identifier = "CFBundleIdentifier"
        }
        
        func makePublic() -> BundleInfo {
            return BundleInfo(name: name, version: version, identifier: identifier)
        }
    }
}
