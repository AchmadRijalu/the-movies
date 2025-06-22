//
//  MoviePreviewViewController.swift
//  the-movies
//
//  Created by Achmad Rijalu on 21/06/25.
//

import UIKit
import SDWebImage

class MoviePreviewViewController: UIViewController {
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func loadView() {
        let rootView = UIView()
        rootView.backgroundColor = .clear
        
        rootView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: rootView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor)
        ])
        
        self.view = rootView
    }
    
    init(movieNowPlayingListCellModel: MovieNowPlayingListCellModel) {
        super.init(nibName: nil, bundle: nil)
        configure(movieListCellModel: movieNowPlayingListCellModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(movieListCellModel: MovieNowPlayingListCellModel) {
        guard let url = URL(string: "\(Endpoints.Gets.image(imageFilePath: movieListCellModel.posterImage).url)") else { return }
        posterImageView.sd_setImage(with: url)
    }
}


