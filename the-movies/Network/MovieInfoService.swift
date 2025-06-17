//
//  MovieInfoService.swift
//  the-movies
//
//  Created by Achmad Rijalu on 16/06/25.
//

import Alamofire
import SwiftyJSON

class MovieInfoService {
    static let shared = MovieInfoService()
    
    var movieInfoDataModel: MovieInfoDataModel?
    var movieVideoDataModel: MovieInfoVideoDataModel?
    var movieReviewDataModel: MovieInfoReviewDataModel?
    
    func fetchMovieInfoData(movidId: Int, completionBlock: @escaping(MovieInfoDataModel?, Error?) -> Void)  {
        let endpoint = Endpoints.Gets.movieInfo(movieId: movidId)
        let url = endpoint.url
        let headers = APICall.headers

        AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers,).responseData { movieData in
            switch movieData.result {
            case .success(let response):
                let data = JSON(response)
                let movieInfoData = MovieInfoDataModel(json: data)
                self.movieInfoDataModel = movieInfoData
                completionBlock(movieInfoData, nil)
            case .failure(let error):
                completionBlock(nil, error)
            }
        }

    }
    
    func fetchVideoMovie(movidId: Int, completionBlock: @escaping(MovieInfoVideoDataModel?, Error?) -> Void)  {
        let endpoint = Endpoints.Gets.movieVideo(movieId: movidId)
        let url = endpoint.url
        let headers = APICall.headers

        AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers,).responseData { movieData in
            switch movieData.result {
            case .success(let response):
                let data = JSON(response)
                let movieVideoData = MovieInfoVideoDataModel(json: data)
                self.movieVideoDataModel = movieVideoData
                completionBlock(movieVideoData, nil)
            case .failure(let error):
                completionBlock(nil, error)
            }
        }

    }
    
    func mapMovieInfoData() -> MovieInfoModel {
        let movieInfoData: MovieInfoModel = MovieInfoModel(title: movieInfoDataModel?.title ?? "", overview: movieInfoDataModel?.overview ?? "", releaseDate: movieInfoDataModel?.releaseDate ?? "", voteAverage: movieInfoDataModel?.voteAverage ?? 0.0)
        return movieInfoData
    }
    
    func mapMovieVideoData() -> [MovieInfoVideoModel] {
        guard let movieVideoData = movieVideoDataModel?.results else {return []}
        var movieVideos : [MovieInfoVideoModel] = []
        for movieVideo in movieVideoData {
            let videoData: MovieInfoVideoModel = MovieInfoVideoModel(id: movieVideo.id, movieVideoKey: movieVideo.key)
            movieVideos.append(videoData)
        }
        return movieVideos
    }
}
