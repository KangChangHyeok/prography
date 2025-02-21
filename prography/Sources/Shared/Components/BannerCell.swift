//
//  BannerCell.swift
//  prography
//
//  Created by kangChangHyeok on 17/02/2025.
//

import UIKit

final class BannerCell: UICollectionViewCell {
    
    // MARK: - UI
    
    private var movieImageView = UIImageView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 26
        $0.backgroundColor = .black
    }
    
    private var titleLabel = UILabel().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Title"
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.font = .pretendard(size: 16, weight: .bold)
    }
    
    private var descriptionLabel = UILabel().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "description"
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.font = .pretendard(size: 11, weight: .semibold)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ backdrop: Backdrop) {
        Task {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://image.tmdb.org/t/p/w300" + backdrop.path)!)
            let movieImage = UIImage(data: data)
            movieImageView.image = movieImage
        }
        titleLabel.text = backdrop.title
        descriptionLabel.text = backdrop.overView
    }
}


private extension BannerCell {
    func configureLayout() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        let movieImageViewLayoutConstraint: [NSLayoutConstraint] = [
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ]
        NSLayoutConstraint.activate(movieImageViewLayoutConstraint)
        
        let titleLabelLayoutConstraint: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 145),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
        ]
        NSLayoutConstraint.activate(titleLabelLayoutConstraint)
        
        let descriptionLabelLayout: [NSLayoutConstraint] = [
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(descriptionLabelLayout)
    }
}
