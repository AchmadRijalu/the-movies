//
//  MovieNowPlayingViewModel.swift
//  the-movies
//
//  Created by Achmad Rijalu on 16/06/25.
//

import RxSwift

protocol MovieNowPlayingViewModelProtocol: AnyObject {
    var delegate: MovieNowPlayingViewModelDelegate? { get set }
    func onViewDidLoad()
    func getNowPlayingList() -> [MovieNowPlayingListCellModel]
    func onMovieNowPlayingDidTap(movieNowPlayingListCellModel: MovieNowPlayingListCellModel)
    //MARK: - Pagination method
    func onScrollToBottom()
}

protocol MovieNowPlayingViewModelDelegate: AnyObject {
    func onSetupView()
    func onReload()
    func navigateToMovieInfo(movieId: Int)
    func showErrorBottomSheet(message: String)
}

class MovieNowPlayingViewModel: MovieNowPlayingViewModelProtocol {
    
    weak var delegate: MovieNowPlayingViewModelDelegate?
    
    private var nowPlayingMovieListCellModel: [MovieNowPlayingListCellModel] = []
    private var currentPage = 1
    private let disposebag = DisposeBag()
    
    func onViewDidLoad() {
        nowPlayingMovieListCellModel.removeAll()
        delegate?.onSetupView()
        fetchMovieNowPlayingList(page: currentPage)
    }
    
    func getNowPlayingList() -> [MovieNowPlayingListCellModel] {
        return nowPlayingMovieListCellModel
    }
    
    func onMovieNowPlayingDidTap(movieNowPlayingListCellModel: MovieNowPlayingListCellModel) {
        delegate?.navigateToMovieInfo(movieId: movieNowPlayingListCellModel.id)
    }
    
    func onScrollToBottom(){
        currentPage += 1
        fetchMovieNowPlayingList(page: currentPage)
    }
}

extension MovieNowPlayingViewModel {
    func fetchMovieNowPlayingList(page: Int) {
        MovieNowPlayingListService.shared.fetchMovieNowPlayingListData(page: page).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] movieData in
            guard let self = self else {return}
            if let movieData, !movieData.isEmpty {
                let newMovieData = MovieNowPlayingListService.shared.convertNowPlayingListDataToListCell(from: movieData)
                self.nowPlayingMovieListCellModel.append(contentsOf: newMovieData)
                self.delegate?.onReload()
            }
        }, onError: { [weak self] _ in
            self?.delegate?.showErrorBottomSheet(message: "Failed to Load the Movie Data")
        }
        ).disposed(by: disposebag)
        
    }
}




