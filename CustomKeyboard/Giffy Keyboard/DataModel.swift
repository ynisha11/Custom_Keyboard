//
//  DataModel.swift
//  CustomKeyboard
//
//  Created by Nisha  on 04/11/18.
//  Copyright © 2018 Nisha . All rights reserved.
//

import Foundation

struct DataModel: Codable {
    var gifArray: [GifData]

    enum CodingKeys : String, CodingKey {
        case gifArray = "data"
    }
}

struct GifData: Codable {
    var images: GifImages

    enum CodingKeys : String, CodingKey {
        case images = "images"
    }
}

struct GifImages: Codable {
    var original: GifOriginal
    enum CodingKeys : String, CodingKey {
        case original = "original"
    }
}

struct GifOriginal: Codable {
    var url: URL
    enum CodingKeys : String, CodingKey {
        case url = "url"
    }
}
