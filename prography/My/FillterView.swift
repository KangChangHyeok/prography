//
//  FillterView.swift
//  prography
//
//  Created by kangChangHyeok on 19/02/2025.
//

import UIKit

final class FillterView: UIView {

    lazy var starRateFillterCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createStarRateCollectionViewLayout()
    ).configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bounces = false
        $0.isScrollEnabled = false
    }
    
    private var fillterCollectionViewDataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
    init() {
        super.init(frame: .zero)
        configure()
        configureLayout()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.masksToBounds = true
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.main.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
    }
    
    private func createStarRateCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureLayout() {
        
        addSubview(starRateFillterCollectionView)
        let fillterCollectionViewLayoutConstraints: [NSLayoutConstraint] = [
            starRateFillterCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            starRateFillterCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            starRateFillterCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            starRateFillterCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            starRateFillterCollectionView.heightAnchor.constraint(equalToConstant: 280)
        ]
        
        NSLayoutConstraint.activate(fillterCollectionViewLayoutConstraints)
    }
    
    private func configureDataSource() {
        let cellRegistaration = UICollectionView.CellRegistration<StarRateCell, Int> { cell, indexPath, starRate in
            cell.bind(starRate: starRate)
            cell.tag = starRate
        }
        
        fillterCollectionViewDataSource = UICollectionViewDiffableDataSource<Int, Int>(
            collectionView: starRateFillterCollectionView
        ) { collectionView, indexPath, starRate in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistaration, for: indexPath, item: starRate)
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapShot.appendSections([0])
        snapShot.appendItems([-1, 5, 4, 3, 2, 1, 0])
        fillterCollectionViewDataSource.apply(snapShot)
    }
}
