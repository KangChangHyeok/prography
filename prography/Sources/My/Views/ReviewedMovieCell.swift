//
//  ReviewedMovieCell.swift
//  prography
//
//  Created by kangChangHyeok on 19/02/2025.
//

import UIKit

final class ReviewedMovieCell: UICollectionViewCell {
    
    // MARK: - UI
    
    private var movieImageView = UIImageView().configure {
        $0.backgroundColor = .black
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var movieTitleLabel = UILabel().configure {
        $0.font = .pretendard(size: 14, weight: .semibold)
        $0.text = "movie Title"
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
    }
    
    private let movieStarRateView = StarRateView(isEdit: false)
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ review: Review) {
        movieImageView.image = UIImage(data: review.movieImage!)
        movieTitleLabel.text = review.movieTitle
        movieStarRateView.set(rate: Int(review.rate))
    }
}

// MARK: - Helper

private extension ReviewedMovieCell {
    
    func configureLayout() {
        contentView.addSubview(movieImageView)
        
        let movieImageViewLayoutConstraints: [NSLayoutConstraint] = [
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 180)
        ]
        
        NSLayoutConstraint.activate(movieImageViewLayoutConstraints)
        
        contentView.addSubview(movieTitleLabel)
        
        let movietitleLabelLayoutConstraints: [NSLayoutConstraint] = [
            movieTitleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 4),
            movieTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieTitleLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        NSLayoutConstraint.activate(movietitleLabelLayoutConstraints)
        
        contentView.addSubview(movieStarRateView)
        
        let movieStarRateViewLayoutConstraints: [NSLayoutConstraint] = [
            movieStarRateView.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor),
            movieStarRateView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            movieStarRateView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ]
        
        NSLayoutConstraint.activate(movieStarRateViewLayoutConstraints)
    }
}
