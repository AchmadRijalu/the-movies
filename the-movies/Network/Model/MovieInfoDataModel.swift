//
//  MovieInfoModel.swift
//  the-movies
//
//  Created by Achmad Rijalu on 16/06/25.
//

import Foundation
import SwiftyJSON

struct MovieInfoDataModel {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let backdropPath: String?
    let runtime: Int
    let voteAverage: Double
    let voteCount: Int
    let tagline: String
    let status: String
    let homepage: String
    let genres: [String]
    let spokenLanguages: [String]
    let productionCompanies: [String]
    let productionCountries: [String]
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.originalTitle = json["original_title"].stringValue
        self.overview = json["overview"].stringValue
        self.releaseDate = json["release_date"].stringValue
        self.posterPath = json["poster_path"].string
        self.backdropPath = json["backdrop_path"].string
        self.runtime = json["runtime"].intValue
        self.voteAverage = json["vote_average"].doubleValue
        self.voteCount = json["vote_count"].intValue
        self.tagline = json["tagline"].stringValue
        self.status = json["status"].stringValue
        self.homepage = json["homepage"].stringValue
        
        self.genres = json["genres"].arrayValue.map { $0["name"].stringValue }
        self.spokenLanguages = json["spoken_languages"].arrayValue.map { $0["english_name"].stringValue }
        self.productionCompanies = json["production_companies"].arrayValue.map { $0["name"].stringValue }
        self.productionCountries = json["production_countries"].arrayValue.map { $0["name"].stringValue }
    }
}
