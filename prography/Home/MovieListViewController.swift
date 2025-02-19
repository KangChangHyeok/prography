//
//  MovieListViewController.swift
//  prography
//
//  Created by kangChangHyeok on 18/02/2025.
//

import UIKit

class MovieListViewController: UIViewController {
    
    lazy var movieCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: movieCollectionViewLayout()
    ).configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
        $0.bounces = true
        $0.allowsSelection = false
        $0.showsVerticalScrollIndicator = false
    }
    
    var movieDataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        configureDataSource()
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems(Array(0..<10))
        movieDataSource.apply(snapshot)
    }
}

private extension MovieListViewController {
    
    func movieCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)

        section.interGroupSpacing = 16
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureLayout() {
        view.addSubview(movieCollectionView)
        let movieCollectionViewLayoutConstraints: [NSLayoutConstraint] = [
            movieCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            movieCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(movieCollectionViewLayoutConstraints)
    }
    
    func configureDataSource() {
        let cellRegistaration = UICollectionView.CellRegistration<MovieCell, Int> { cell, indexPath, movie in
            
        }
        
        movieDataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: movieCollectionView) { collectionView, indexPath, movieId in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistaration, for: indexPath, item: movieId)
        }
    }
}
