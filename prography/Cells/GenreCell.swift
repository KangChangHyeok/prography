//
//  GenreCell.swift
//  prography
//
//  Created by kangChangHyeok on 18/02/2025.
//

import UIKit

final class GenreCell: UICollectionViewCell {
    
    private var genreLabel = UILabel().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pretendard(size: 11, weight: .semibold)
        $0.textColor = .prograhpyGray
        $0.textAlignment = .center
        $0.text = "Genre"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.main.cgColor
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true
        
        contentView.addSubview(genreLabel)
        
        let genreLabelLayoutConstraints: [NSLayoutConstraint] = [
            genreLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            genreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(genreLabelLayoutConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
