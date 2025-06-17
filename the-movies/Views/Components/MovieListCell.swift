//
//  RestaurantCollectionViewCell.swift
//  the-movies
//
//  Created by Achmad Rijalu on 16/06/25.
//

import UIKit
import SDWebImage
import SkeletonView

class MovieListCell: UICollectionViewCell {
    static let identifier = "RestaurantCollectionViewCell"
    
    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var movieRatingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.attributedText = NSAttributedString(string: "City Name", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)])
        label.isSkeletonable = true
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        isSkeletonable = true
        contentView.isSkeletonable = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isSkeletonable = true
    }
    
    func configureCell(movieListCellModel: MovieNowPlayingListCellModel) {
        movieRatingLabel.text = String("⭐️ \(movieListCellModel.rating)")
        movieImageView.sd_setImage(with: URL(string: "\(Endpoints.Gets.image(imageFilePath: movieListCellModel.posterImage).url)"))
    }
    
}

extension MovieListCell {
    private func setupView() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.addSubview(movieImageView)
        containerView.addSubview(movieRatingLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            movieImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 220),
            
            movieRatingLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 8),
            movieRatingLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
}
