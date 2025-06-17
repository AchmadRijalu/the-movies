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
    func getMovieInfo() -> MovieInfoModel?
    func getMovieYoutubeKeyId() -> [String]
    
}

protocol MovieInfoViewModelDelegate: AnyObject {
    func setupView(youtubeKeyId: [String])
}

class MovieInfoViewModel: MovieInfoViewModelProtocol {
    weak var delegate: MovieInfoViewModelDelegate?
    
    private let movieId: Int
    private var movieInfoModel: MovieInfoModel?
    private var movieInfoVideoModel: [MovieInfoVideoModel]?
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    func onViewDidLoad() {
        fetchMovieInfo(movieId: movieId)
        fetchMovieVideo(movieId: movieId)
    }
    
    func getMovieInfo() -> MovieInfoModel? {
        return movieInfoModel
    }
    
    func getMovieYoutubeKeyId() -> [String] {
        return movieInfoVideoModel?.map {$0.movieVideoKey} ?? []
    }
    
}

extension MovieInfoViewModel {
    func fetchMovieInfo(movieId: Int) {
        MovieInfoService.shared.fetchMovieInfoData(movidId: movieId) { [weak self] movieData, error in
            guard let self = self else { return }
            if movieData != nil {
                self.movieInfoModel = MovieInfoService.shared.mapMovieInfoData()
            }
        }
    }
    
    func fetchMovieVideo(movieId: Int) {
        MovieInfoService.shared.fetchVideoMovie(movidId: movieId) { [weak self] movieData, error in
            guard let self = self else { return }
            if movieData != nil {
                movieInfoVideoModel = MovieInfoService.shared.mapMovieVideoData()
                DispatchQueue.main.async {
                    self.delegate?.setupView(youtubeKeyId: self.getMovieYoutubeKeyId())
                }
            }
            
        }
    }
}
