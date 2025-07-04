//
//  ViewController.swift
//  the-movies
//
//  Created by Achmad Rijalu on 16/06/25.
//

import UIKit
import SkeletonView

class MovieListViewController: UIViewController {
    
    var viewModel: MovieNowPlayingViewModelProtocol
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 20, right: 12)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MovieListCell.self, forCellWithReuseIdentifier: MovieListCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
        //MARK: - UIContextMenuInteraction is for enable the uiview is tappable for 3d touch
//        let touchInteraction = UIContextMenuInteraction(delegate: self)
//        view.addInteraction(touchInteraction)
    }
    
    init(viewModel: MovieNowPlayingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieListViewController: MovieNowPlayingViewModelDelegate{
    
    func onSetupView() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        view.addSubview(collectionView)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Now Playing "
        view.isSkeletonable = true
        self.collectionView.isSkeletonable = true
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        self.collectionView.showAnimatedGradientSkeleton()
    }
    
    func onReload() {
        self.collectionView.stopSkeletonAnimation()
        self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.2))
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func navigateToMovieInfo(movieId: Int) {
        guard let navigation = navigationController else {return}
        let viewModel: MovieInfoViewModel = MovieInfoViewModel(movieId: movieId)
        let view = MovieInfoViewController(viewModel: viewModel)
        navigation.pushViewController(view, animated: true)
    }
    
    func showErrorBottomSheet(message: String) {
        let bottomSheet = ErrorBottomSheet(message: message)
        present(bottomSheet, animated: true)
    }
    
}
extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffSet = collectionView.contentOffset.y
        let maximumOffSet = collectionView.contentSize.height - collectionView.frame.size.height
        
        if currentOffSet >= maximumOffSet {
            viewModel.onScrollToBottom()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNowPlayingList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCell.identifier, for: indexPath) as? MovieListCell else {
           return UICollectionViewCell()
        }
        cell.configureCell(movieListCellModel: viewModel.getNowPlayingList()[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfColumns: CGFloat = 3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalHorizontalInsets = layout.sectionInset.left + layout.sectionInset.right
        let totalSpacingBetweenItems = layout.minimumInteritemSpacing * (numberOfColumns - 1)

        let availableWidth = collectionView.bounds.width - totalHorizontalInsets - totalSpacingBetweenItems
        let itemWidth = floor(availableWidth / numberOfColumns)
        
        let itemHeight = itemWidth * 1.8

        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieData = viewModel.getNowPlayingList()[indexPath.row]
        viewModel.onMovieNowPlayingDidTap(movieNowPlayingListCellModel: movieData)
    }
    //MARK: - 3D Touch Peek and Pop
     func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPaths: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
         let movieData = viewModel.getNowPlayingList()[indexPaths.row]
        return UIContextMenuConfiguration(identifier: indexPaths as NSCopying) {
            return MoviePreviewViewController(movieNowPlayingListCellModel: movieData)
        } actionProvider: { action in
            return self.makeContextMenu()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: any UIContextMenuInteractionCommitAnimating) {
        guard let movieDataIndexPath = configuration.identifier as? IndexPath else { return }
        let movieData = viewModel.getNowPlayingList()[movieDataIndexPath.row]
        animator.addAnimations {
            self.viewModel.onMovieNowPlayingDidTap(movieNowPlayingListCellModel: movieData)
        }
    }
    
    func makeContextMenu() -> UIMenu {
        let shareAction: UIAction = UIAction(title: "Share Movie", image: UIImage(systemName: "square.and.arrow.up")) { action in
            
        }
        let deleteAction: UIAction = UIAction(title: "Delete Movie", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            
        }
        return UIMenu(children: [shareAction, deleteAction])
    }
    
}

extension MovieListViewController: SkeletonCollectionViewDataSource, SkeletonCollectionViewDelegate {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return MovieListCell.identifier
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}
