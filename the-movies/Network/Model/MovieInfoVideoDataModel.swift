//
//  MovieInfoVideoDataModel.swift
//  the-movies
//
//  Created by Achmad Rijalu on 16/06/25.
//


import Foundation
import SwiftyJSON

struct MovieInfoVideoDataModel {
    let id: Int
    let results: [Video]

    init(json: JSON) {
        self.id = json["id"].intValue
        self.results = json["results"].arrayValue.map { Video(json: $0) }
    }
}

struct Video {
    let id: String
    let iso639_1: String
    let iso3166_1: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String

    init(json: JSON) {
        self.id = json["id"].stringValue
        self.iso639_1 = json["iso_639_1"].stringValue
        self.iso3166_1 = json["iso_3166_1"].stringValue
        self.name = json["name"].stringValue
        self.key = json["key"].stringValue
        self.site = json["site"].stringValue
        self.size = json["size"].intValue
        self.type = json["type"].stringValue
        self.official = json["official"].boolValue
        self.publishedAt = json["published_at"].stringValue
    }
}
