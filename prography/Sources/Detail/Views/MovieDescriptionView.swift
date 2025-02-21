//
//  MovieDescriptionView.swift
//  prography
//
//  Created by kangChangHyeok on 19/02/2025.
//

import UIKit

final class MovieDescriptionView: UIView {
    
    // MARK: - Properties
    
    private var genreDataSource: UICollectionViewDiffableDataSource<Int, String>!
    
    // MARK: - UI
    
    private let titleLabel = MovieTitleLabel().configure {
        $0.textColor = .black
        $0.set(title: "Title", rate: 4.8)
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
    
    private var descriptionLabel = UILabel().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 24
        paragraphStyle.maximumLineHeight = 24
        paragraphStyle.lineSpacing = 3
    }
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(title: String, rate: Double ,genres: [String], description: String) {
        titleLabel.set(title: title, rate: rate)
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, String>()
        snapShot.appendSections([0])
        snapShot.appendItems(genres)
        genreDataSource.apply(snapShot)
        
        descriptionLabel.text = description
    }
}

// MARK: - Helper

private extension MovieDescriptionView {
    
    func genreCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(40), heightDimension: .estimated(16))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(40), heightDimension: .estimated(16))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 5
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureLayout() {
        self.addSubview(titleLabel)
        
        let titleLabelLayoutConstraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(titleLabelLayoutConstraints)
        
        self.addSubview(genreCollectionView)
        
        let genreCollectionViewLayoutConstraints: [NSLayoutConstraint] = [
            genreCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            genreCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            genreCollectionView.heightAnchor.constraint(equalToConstant: 18),
            genreCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(genreCollectionViewLayoutConstraints)
        
        self.addSubview(descriptionLabel)
        
        let descriptionLabelLayoutConstraints: [NSLayoutConstraint] = [
            descriptionLabel.topAnchor.constraint(equalTo: genreCollectionView.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(descriptionLabelLayoutConstraints)
    }
    
    func configureDataSource() {
        let cellRegistaration = UICollectionView.CellRegistration<GenreCell, String> { cell, indexPath, genre in
            cell.bind(genre)
        }
        
        genreDataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: genreCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistaration, for: indexPath, item: itemIdentifier)
        })
    }
}
