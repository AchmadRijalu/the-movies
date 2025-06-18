//
//  NowPlayingMovieListService.swift
//  the-movies
//
//  Created by Achmad Rijalu on 16/06/25.
//

import Alamofire
import SwiftyJSON
import RxSwift

class MovieNowPlayingListService {
    static let shared = MovieNowPlayingListService()
    
    var nowPlayingMoviesList: [MovieNowPlayingResultModel]?
    
    func fetchMovieNowPlayingListData(page: Int,) -> Observable<[MovieNowPlayingResultModel]?>  {
        let endpoint = Endpoints.Gets.movieNowPlaying(page: page)
        let url = endpoint.url
        let headers = APICall.headers

        return Observable<[MovieNowPlayingResultModel]?>.create { observer in
            AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseData { movieData in
                switch movieData.result {
                case .success(let response):
                    let data = JSON(response)
                    let nowPlayingMovies = MovieNowPlayingModel(json: data)
                    let movieResults = nowPlayingMovies.results ?? []
                    if self.nowPlayingMoviesList == nil {
                        self.nowPlayingMoviesList = movieResults
                    } else {
                        self.nowPlayingMoviesList?.append(contentsOf: movieResults)
                    }
                    observer.onNext(movieResults)
                    observer.onCompleted()

                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        
    }

    func convertNowPlayingListDataToListCell(from results: [MovieNowPlayingResultModel]) -> [MovieNowPlayingListCellModel] {
        return results.map {
            MovieNowPlayingListCellModel(
                id: $0.id ?? 0,
                posterImage: $0.posterPath ?? "-",
                rating: $0.voteAverage ?? 0
            )
        }
    }
}
