//
//  MovieInfoViewModel.swift
//  the-movies
//
//  Created by Achmad Rijalu on 16/06/25.
//

import Foundation
import RxSwift

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
    private var movieReviewListCellModel: [MovieReviewListCellModel]?
    private let disposeBag = DisposeBag()
    
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
        return movieReviewListCellModel ?? []
    }
    
}

extension MovieInfoViewModel {
    func fetchMovieDetailData(movieId: Int) {
        let infoObservable = MovieInfoService.shared.fetchMovieInfoData(movidId: movieId)
        let videoObservable = MovieInfoService.shared.fetchVideoMovie(movidId: movieId)
        let reviewObservable = MovieInfoService.shared.fetchMovieReview(movidId: movieId)
        
        Observable.zip(infoObservable, videoObservable, reviewObservable)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] infoData, videoData, reviewData in
                guard let self = self else { return }
                
                self.movieInfoModel = MovieInfoService.shared.mapMovieInfoData()
                self.movieInfoVideoModel = MovieInfoService.shared.mapMovieVideoData()
                self.movieReviewListCellModel = MovieInfoService.shared.convertMovieReviewListDataToListCell()
                
                guard let movieInfo = self.movieInfoModel else {
                    self.delegate?.showErrorBottomSheet(message: "Oops! Something went wrong.")
                    return
                }
                
                let youtubeIds = self.getMovieYoutubeKeyId()
                let reviewList = self.getMovieReviews()
                
                self.delegate?.setupConfigureView(
                    youtubeKeyId: youtubeIds,
                    movieInfoModel: movieInfo,
                    movieReviewListCellModel: reviewList
                )
                self.delegate?.onReload()
                
            }, onError: { [weak self] error in
                self?.delegate?.showErrorBottomSheet(message: "Failed to fetch the Movie Data.")
            })
            .disposed(by: disposeBag)
    }
}



