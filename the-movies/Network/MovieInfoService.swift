//
//  MovieInfoService.swift
//  the-movies
//
//  Created by Achmad Rijalu on 16/06/25.
//

import Alamofire
import SwiftyJSON
import RxSwift

class MovieInfoService {
    static let shared = MovieInfoService()
    
    var movieInfoDataModel: MovieInfoDataModel?
    var movieVideoDataModel: MovieInfoVideoDataModel?
    var movieReviewDataModel: MovieInfoReviewDataModel?
    
    func fetchMovieInfoData(movidId: Int) -> Observable<MovieInfoDataModel?>  {
        let endpoint = Endpoints.Gets.movieInfo(movieId: movidId)
        let url = endpoint.url
        let headers = APICall.headers
        
        return Observable<MovieInfoDataModel?>.create { observer in
            AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers,).responseData { movieData in
                switch movieData.result {
                case .success(let response):
                    let data = JSON(response)
                    let movieInfoData = MovieInfoDataModel(json: data)
                    self.movieInfoDataModel = movieInfoData
                    observer.onNext(movieInfoData)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchVideoMovie(movidId: Int) -> Observable<MovieInfoVideoDataModel?>  {
        let endpoint = Endpoints.Gets.movieVideo(movieId: movidId)
        let url = endpoint.url
        let headers = APICall.headers
        
        return Observable<MovieInfoVideoDataModel?>.create { observer in
            AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers,).responseData { movieData in
                switch movieData.result {
                case .success(let response):
                    let data = JSON(response)
                    let movieVideoData = MovieInfoVideoDataModel(json: data)
                    self.movieVideoDataModel = movieVideoData
                    observer.onNext(movieVideoData)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchMovieReview(movidId: Int) -> Observable<MovieInfoReviewDataModel?>  {
        let endpoint = Endpoints.Gets.movieReview(movieId: movidId)
        let url = endpoint.url
        let headers = APICall.headers
        
        return Observable<MovieInfoReviewDataModel?>.create { observer in
            AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers,).responseData { movieData in
                switch movieData.result {
                case .success(let response):
                    let data = JSON(response)
                    let movieVideoData = MovieInfoReviewDataModel(json: data)
                    self.movieReviewDataModel = movieVideoData
                    observer.onNext(movieVideoData)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}

extension MovieInfoService {
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
    
    func convertMovieReviewListDataToListCell() -> [MovieReviewListCellModel] {
        guard let reviewDatas = movieReviewDataModel?.results else {return []}
        var reviews: [MovieReviewListCellModel] = []
        for review in reviewDatas {
            let movieReviewListCellModel: MovieReviewListCellModel = MovieReviewListCellModel(name: review.author, rating: review.rating ?? 0.0, content: review.content)
            reviews.append(movieReviewListCellModel)
        }
        return reviews
    }
}
