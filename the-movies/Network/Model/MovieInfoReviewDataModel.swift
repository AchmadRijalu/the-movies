//
//  MovieInfoReviewDataModel.swift
//  the-movies
//
//  Created by Achmad Rijalu on 16/06/25.
//

import Foundation
import SwiftyJSON

struct MovieInfoReviewDataModel {
    let id: Int
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [Review]

    init(json: JSON) {
        self.id = json["id"].intValue
        self.page = json["page"].intValue
        self.totalPages = json["total_pages"].intValue
        self.totalResults = json["total_results"].intValue
        self.results = json["results"].arrayValue.map { Review(json: $0) }
    }
}

struct Review {
    let id: String
    let author: String
    let content: String
    let rating: Double?
    let createdAt: String
    let updatedAt: String
    let url: String
    let authorDetails: AuthorDetails

    init(json: JSON) {
        self.id = json["id"].stringValue
        self.author = json["author"].stringValue
        self.content = json["content"].stringValue
        self.rating = json["author_details"]["rating"].double
        self.createdAt = json["created_at"].stringValue
        self.updatedAt = json["updated_at"].stringValue
        self.url = json["url"].stringValue
        self.authorDetails = AuthorDetails(json: json["author_details"])
    }
}

struct AuthorDetails {
    let name: String
    let username: String
    let avatarPath: String?
    let rating: Double?

    init(json: JSON) {
        self.name = json["name"].stringValue
        self.username = json["username"].stringValue
        self.avatarPath = json["avatar_path"].string
        self.rating = json["rating"].double
    }
}

