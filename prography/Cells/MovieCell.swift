//
//  MovieCell.swift
//  prography
//
//  Created by kangChangHyeok on 18/02/2025.
//

import UIKit

final class MovieCell: UICollectionViewCell {
    
    private lazy var containerStackView = UIStackView(
        arrangedSubviews: [titleLabel, descriptionLabel, rateLabel, genreCollectionView]
    ).configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    private let movieImageView = UIImageView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .black
    }
    
    private let titleLabel = UILabel().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pretendard(size: 22, weight: .bold)
        $0.text = "Title"
        $0.textColor = .black
    }
    
    private let descriptionLabel = UILabel().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.numberOfLines = 2
        $0.textColor = .prograhpyGray
        $0.text = "verview는 두 줄이 넘지 않게 구현해주세요."
    }
    
    private let rateLabel = UILabel().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pretendard(size: 14, weight: .semibold)
        $0.textColor = .prograhpyGray
        $0.text = "rate"
    }
    
    private lazy var genreCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: genreCollectionViewLayout()
    ).configure {
        $0.bounces = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
    }
    
    private var genreDataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureDataSource()
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapShot.appendSections([0])
        snapShot.appendItems(Array(0..<4))
        genreDataSource.apply(snapShot)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MovieCell {
    
    func genreCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(40), heightDimension: .absolute(16))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 3.33
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureLayout() {
        contentView.addSubview(movieImageView)
        
        let movieImageViewLayoutConstraints: [NSLayoutConstraint] = [
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            movieImageView.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(movieImageViewLayoutConstraints)
        
        let genreCollectionViewLayoutConstraints: [NSLayoutConstraint] = [
            genreCollectionView.heightAnchor.constraint(equalToConstant: 16)
        ]
        
        NSLayoutConstraint.activate(genreCollectionViewLayoutConstraints)
        
        contentView.addSubview(containerStackView)
        
        let containerStackViewLayoutConstraints: [NSLayoutConstraint] = [
            containerStackView.centerYAnchor.constraint(equalTo: movieImageView.centerYAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        NSLayoutConstraint.activate(containerStackViewLayoutConstraints)
    }
    
    func configureDataSource() {
        let cellRegistaration = UICollectionView.CellRegistration<GenreCell, Int> { cell, indexPath, item in
            
        }
        
        genreDataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: genreCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistaration, for: indexPath, item: itemIdentifier)
        })
        
    }
}
