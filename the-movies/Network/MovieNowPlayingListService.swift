//
//  NowPlayingMovieListService.swift
//  the-movies
//
//  Created by Achmad Rijalu on 16/06/25.
//

import Alamofire
import SwiftyJSON

class MovieNowPlayingListService {
    static let shared = MovieNowPlayingListService()
    
    var nowPlayingMoviesList: [MovieNowPlayingResultModel]?
    
    func fetchMovieNowPlayingListData(page: Int, completionBlock: @escaping([MovieNowPlayingResultModel]?, Error?) -> Void)  {
        let endpoint = Endpoints.Gets.movieNowPlaying(page: page)
        let url = endpoint.url
        let headers = APICall.headers

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
                completionBlock(movieResults, nil)

            case .failure(let error):
                completionBlock(nil, error)
            }
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
