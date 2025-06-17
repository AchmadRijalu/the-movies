//
//  NowPlayingMovieListDataModel.swift
//  the-movies
//
//  Created by Achmad Rijalu on 16/06/25.
//

import Foundation
import SwiftyJSON

struct MovieNowPlayingModel: Equatable, Identifiable {
    let id = UUID()
    var dates: DatesModel?
    var page: Int?
    var results: [MovieNowPlayingResultModel]?
    var totalPages: Int?
    var totalResults: Int?
    
    init(json: JSON) {
        self.dates = DatesModel(json: json["dates"])
        self.page = json["page"].int
        self.totalPages = json["total_pages"].int
        self.totalResults = json["total_results"].int
        self.results = json["results"].arrayValue.map { MovieNowPlayingResultModel(json: $0) }
    }
}

struct DatesModel: Equatable {
    var maximum: String?
    var minimum: String?
    
    init(json: JSON) {
        self.maximum = json["maximum"].string
        self.minimum = json["minimum"].string
    }
}

struct MovieNowPlayingResultModel: Equatable {
    var adult: Bool?
    var backdropPath: String?
    var genreIDs: [Int]?
    var id: Int?
    var originalLanguage: String?
    var originalTitle: String?
    var overview: String?
    var popularity: Double?
    var posterPath: String?
    var releaseDate: String?
    var title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    
    init(json: JSON) {
        self.adult = json["adult"].bool
        self.backdropPath = json["backdrop_path"].string
        self.genreIDs = json["genre_ids"].arrayObject as? [Int]
        self.id = json["id"].int
        self.originalLanguage = json["original_language"].string
        self.originalTitle = json["original_title"].string
        self.overview = json["overview"].string
        self.popularity = json["popularity"].double
        self.posterPath = json["poster_path"].string
        self.releaseDate = json["release_date"].string
        self.title = json["title"].string
        self.video = json["video"].bool
        self.voteAverage = json["vote_average"].double
        self.voteCount = json["vote_count"].int
    }
}
