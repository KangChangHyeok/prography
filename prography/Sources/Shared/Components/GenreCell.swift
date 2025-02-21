//
//  GenreCell.swift
//  prography
//
//  Created by kangChangHyeok on 18/02/2025.
//

import UIKit

final class GenreCell: UICollectionViewCell {
    
    // MARK: - UI
    
    private var genreLabel = UILabel().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pretendard(size: 11, weight: .semibold)
        $0.textColor = .prograhpyGray
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.main.cgColor
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true
        
        contentView.addSubview(genreLabel)
        
        let genreLabelLayoutConstraints: [NSLayoutConstraint] = [
            genreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            genreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ]
        
        NSLayoutConstraint.activate(genreLabelLayoutConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ genre: String) {
        genreLabel.text = genre
    }
}
