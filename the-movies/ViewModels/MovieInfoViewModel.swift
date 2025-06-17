//
//  MovieInfoViewModel.swift
//  the-movies
//
//  Created by Achmad Rijalu on 16/06/25.
//

import Foundation

protocol MovieInfoViewModelProtocol: AnyObject {
    var delegate: MovieInfoViewModelDelegate? { get set }
    func onViewDidLoad()
    func getMovieInfo() -> MovieInfoModel
    func getMovieYoutubeKeyId() -> [String]
    func getMovieReviews() -> [MovieReviewListCellModel]
}

protocol MovieInfoViewModelDelegate: AnyObject {
    func setupConfigureView(youtubeKeyId: [String], movieInfoModel: MovieInfoModel, movieReviewListCellModel: [MovieReviewListCellModel])
    func onReload()
    func showErrorBottomSheet(message: String)
}

class MovieInfoViewModel: MovieInfoViewModelProtocol {
    
    weak var delegate: MovieInfoViewModelDelegate?
    
    private let movieId: Int
    private var movieInfoModel: MovieInfoModel?
    private var movieInfoVideoModel: [MovieInfoVideoModel]?
    private var movieRevieListCellModel: [MovieReviewListCellModel]?
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    func onViewDidLoad() {
        fetchMovieDetailData(movieId: movieId)
    }
    
    func getMovieInfo() -> MovieInfoModel {
        return movieInfoModel!
    }
    
    func getMovieYoutubeKeyId() -> [String] {
        return movieInfoVideoModel?.map {$0.movieVideoKey} ?? []
    }
    
    func getMovieReviews() -> [MovieReviewListCellModel] {
        return movieRevieListCellModel ?? []
    }
    
}

extension MovieInfoViewModel {
    func fetchMovieDetailData(movieId: Int) {
        let group = DispatchGroup()

        var fetchedMovieInfo: MovieInfoModel?
        var fetchedMovieVideos: [MovieInfoVideoModel]?
        var fetchedMovieReviews: [MovieReviewListCellModel]?
        var fetchError: Error?

        group.enter()
        MovieInfoService.shared.fetchMovieInfoData(movidId: movieId) { movieData, error in
            defer { group.leave() }
            if let error = error {
                fetchError = error
            } else if movieData != nil {
                fetchedMovieInfo = MovieInfoService.shared.mapMovieInfoData()
            }
        }

        group.enter()
        MovieInfoService.shared.fetchVideoMovie(movidId: movieId) { videoData, error in
            defer { group.leave() }
            if let error = error, fetchError == nil {
                fetchError = error
            } else if videoData != nil {
                fetchedMovieVideos = MovieInfoService.shared.mapMovieVideoData()
            }
        }

        group.enter()
        MovieInfoService.shared.fetchMovieReview(movidId: movieId) { reviewData, error in
            defer { group.leave() }
            if let error = error, fetchError == nil {
                fetchError = error
            } else if reviewData != nil {
                fetchedMovieReviews = MovieInfoService.shared.convertMovieReviewListDataToListCell()
            }
        }

        group.notify(queue: .main) {
            if fetchError != nil {
                self.delegate?.showErrorBottomSheet(message:  "Failed to fetch the Movie Data.")
                return
            }

            guard let movieInfo = fetchedMovieInfo else {
                self.delegate?.showErrorBottomSheet(message: "Ooppss There is something wrong!")
                return
            }

            self.movieInfoModel = movieInfo
            self.movieInfoVideoModel = fetchedMovieVideos
            self.movieRevieListCellModel = fetchedMovieReviews

            let youtubeIds = self.getMovieYoutubeKeyId()
            self.delegate?.setupConfigureView(
                youtubeKeyId: youtubeIds,
                movieInfoModel: movieInfo,
                movieReviewListCellModel: self.getMovieReviews()
            )
            self.delegate?.onReload()
        }
    }

}


