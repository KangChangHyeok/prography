//
//  MovieListViewController.swift
//  prography
//
//  Created by kangChangHyeok on 18/02/2025.
//

import UIKit

class MovieListViewController: UIViewController {
    
    // MARK: - Properties
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Movie>!
    
    // MARK: - UI
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    ).configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
        $0.bounces = true
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
    }
}

// MARK: - Helper

private extension MovieListViewController {
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
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
        view.addSubview(collectionView)
        let movieCollectionViewLayoutConstraints: [NSLayoutConstraint] = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(movieCollectionViewLayoutConstraints)
    }
    
    func configureDataSource() {
        let cellRegistaration = UICollectionView.CellRegistration<MovieCell, Movie> { cell, indexPath, movie in
            cell.bind(movie)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Movie>(collectionView: collectionView) { collectionView, indexPath, movie in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistaration, for: indexPath, item: movie)
        }
    }
}
