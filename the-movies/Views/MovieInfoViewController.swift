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
    
    private lazy var backButtonContainer: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 17.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButtonImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.image = UIImage(systemName: "arrowshape.turn.up.backward")
        image.tintColor = .black
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewModel.onViewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
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

extension MovieInfoViewController: MovieInfoViewModelDelegate {
    
    func setupView(youtubeKeyId: [String]) {
        let player = YouTubePlayer(source: .videos(ids: youtubeKeyId))
        youTubePlayerHostingView = YouTubePlayerHostingView(player: player)
        youTubePlayerHostingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(youTubePlayerHostingView)
        view.addSubview(backButtonContainer)
        backButtonContainer.addSubview(backButtonImageView)

        NSLayoutConstraint.activate([
            youTubePlayerHostingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            youTubePlayerHostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            youTubePlayerHostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            youTubePlayerHostingView.heightAnchor.constraint(equalTo: youTubePlayerHostingView.widthAnchor, multiplier: 9.0/16.0),
            
            backButtonContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backButtonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            backButtonContainer.widthAnchor.constraint(equalToConstant: 35),
            backButtonContainer.heightAnchor.constraint(equalToConstant: 35),

            backButtonImageView.centerXAnchor.constraint(equalTo: backButtonContainer.centerXAnchor),
            backButtonImageView.centerYAnchor.constraint(equalTo: backButtonContainer.centerYAnchor),
            backButtonImageView.widthAnchor.constraint(equalToConstant: 20),
            backButtonImageView.heightAnchor.constraint(equalToConstant: 20)
        ])

        setupAction()
    }
    
    func setupAction() {
        backButtonContainer.isUserInteractionEnabled = true
        backButtonContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backButtonTapped)))
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}



