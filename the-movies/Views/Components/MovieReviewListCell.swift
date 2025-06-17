//
//  MovieReviewListCell.swift
//  the-movies
//
//  Created by Achmad Rijalu on 17/06/25.
//

import UIKit
import SkeletonView

class MovieReviewListCell: UICollectionViewCell {
    static let identifier = "MovieReviewListCell"
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 1
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 0
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isSkeletonable = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configure(userName: String, rating: Double, review: String) {
        userNameLabel.text = userName
        ratingLabel.text = "★ \(String(format: "%.1f", rating))"
        reviewLabel.text = review
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.text = nil
        ratingLabel.text = nil
        reviewLabel.text = nil
    }
    
    private func setupView() {
        contentView.isSkeletonable = true
        contentView.addSubview(containerView)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(ratingLabel)
        containerView.addSubview(reviewLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            userNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            userNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            ratingLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            ratingLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            ratingLabel.leadingAnchor.constraint(greaterThanOrEqualTo: userNameLabel.trailingAnchor, constant: 8),
            
            reviewLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            reviewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            reviewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            reviewLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
}
