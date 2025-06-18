//
//  MovieInfoViewController.swift
//  the-movies
//
//  Created by Achmad Rijalu on 16/06/25.
//

import UIKit
import YouTubePlayerKit
import SkeletonView

class MovieInfoViewController: UIViewController {

    var viewModel: MovieInfoViewModelProtocol
    private var youTubePlayerHostingView: YouTubePlayerHostingView!
    
    private lazy var movieVideoContainer: UIView = {
        let view = UIView(frame: .zero)
        view.isSkeletonable = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var backButtonContainer: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var backButtonImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "chevron.backward")
        image.tintColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var movieTitle: UILabel = {
        let label = UILabel()
        label.text = "Movie Title"
        label.textAlignment = .left
        label.textColor = .white
        label.isSkeletonable = true
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieDescription: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Description"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var movieReviews: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.isSkeletonable = true
        collectionView.register(MovieReviewListCell.self, forCellWithReuseIdentifier: MovieReviewListCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupView()
        viewModel.onViewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    init(viewModel: MovieInfoViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieInfoViewController {
    private func setupView() {
        view.addSubview(movieVideoContainer)
        view.addSubview(movieTitle)
        view.addSubview(backButtonContainer)
        view.addSubview(movieDescription)
        view.addSubview(movieReviews)
        backButtonContainer.addSubview(backButtonImageView)
        movieVideoContainer.isUserInteractionEnabled = true
        backButtonContainer.isUserInteractionEnabled = true
        backButtonContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backButtonTapped)))
        
        NSLayoutConstraint.activate([
            movieVideoContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieVideoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieVideoContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieVideoContainer.heightAnchor.constraint(equalToConstant: 250),

            movieTitle.topAnchor.constraint(equalTo: movieVideoContainer.bottomAnchor, constant: 12),
            movieTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            movieDescription.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 12),
            movieDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            movieDescription.trailingAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: view.trailingAnchor, multiplier: -12),
            
            movieReviews.topAnchor.constraint(equalTo: movieDescription.bottomAnchor, constant: 12),
            movieReviews.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieReviews.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieReviews.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButtonContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backButtonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            backButtonContainer.widthAnchor.constraint(equalToConstant: 40),
            backButtonContainer.heightAnchor.constraint(equalToConstant: 40),

            backButtonImageView.centerXAnchor.constraint(equalTo: backButtonContainer.centerXAnchor),
            backButtonImageView.centerYAnchor.constraint(equalTo: backButtonContainer.centerYAnchor),
        ])
        view.isSkeletonable = true
        movieVideoContainer.showAnimatedGradientSkeleton()
        movieReviews.showAnimatedGradientSkeleton()
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension MovieInfoViewController: MovieInfoViewModelDelegate {
    
    func setupConfigureView(youtubeKeyId: [String], movieInfoModel: MovieInfoModel, movieReviewListCellModel: [MovieReviewListCellModel]) {
        let player = YouTubePlayer(source: .videos(ids: youtubeKeyId))
        youTubePlayerHostingView = YouTubePlayerHostingView(player: player)
        youTubePlayerHostingView.translatesAutoresizingMaskIntoConstraints = false
        if youTubePlayerHostingView.superview == nil {
            movieVideoContainer.addSubview(youTubePlayerHostingView)
            NSLayoutConstraint.activate([
                youTubePlayerHostingView.topAnchor.constraint(equalTo: movieVideoContainer.topAnchor),
                youTubePlayerHostingView.leadingAnchor.constraint(equalTo: movieVideoContainer.leadingAnchor),
                youTubePlayerHostingView.trailingAnchor.constraint(equalTo: movieVideoContainer.trailingAnchor),
                youTubePlayerHostingView.bottomAnchor.constraint(equalTo: movieVideoContainer.bottomAnchor)
            ])
        }
       movieTitle.text = movieInfoModel.title
        movieDescription.text = movieInfoModel.overview
    }
    
    func onReload() {
        self.movieReviews.stopSkeletonAnimation()
        self.movieVideoContainer.stopSkeletonAnimation()
        self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.2))
        DispatchQueue.main.async {
            self.movieReviews.reloadData()
        }
    }
    
    func showErrorBottomSheet(message: String) {
        let bottomSheet = ErrorBottomSheet(message: message)
        present(bottomSheet, animated: true)
    }
}

extension MovieInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getMovieReviews().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieReviewListCell.identifier, for: indexPath) as? MovieReviewListCell else {
            return UICollectionViewCell()
        }
        cell.configure(userName: viewModel.getMovieReviews()[indexPath.row].name, rating: viewModel.getMovieReviews()[indexPath.row].rating, review: viewModel.getMovieReviews()[indexPath.row].content)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 200)
    }
}

extension MovieInfoViewController: SkeletonCollectionViewDataSource, SkeletonCollectionViewDelegate {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return MovieReviewListCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
}




