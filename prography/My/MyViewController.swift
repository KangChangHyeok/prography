//
//  MyViewController.swift
//  prography
//
//  Created by kangChangHyeok on 17/02/2025.
//

import UIKit

final class MyViewController: UIViewController {
    
    private var starRatingView = StarRatingView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var reviewedMovieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createReviewedMovieCollectionViewLayout()).configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
    }
    
    private var reviewedMovieDataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
    override func viewDidLoad() {
        configureLayout()
        configureDataSource()
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

}

private extension MyViewController {
    
    func createReviewedMovieCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(240))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 8
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureLayout() {
        view.addSubview(reviewedMovieCollectionView)
        view.addSubview(starRatingView)

        let starRatingViewLayoutConstraints: [NSLayoutConstraint] = [
            starRatingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            starRatingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            starRatingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(starRatingViewLayoutConstraints)
        
        
        
        let reviewedMovieCollectionViewLayoutConstraints: [NSLayoutConstraint] = [
            reviewedMovieCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 96),
            reviewedMovieCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            reviewedMovieCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            reviewedMovieCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(reviewedMovieCollectionViewLayoutConstraints)
    }
    
    func configureDataSource() {
        let cellRegistaration = UICollectionView.CellRegistration<ReviewedMovieCell, Int> { cell, indexPath, movieId in
            
        }
        
        reviewedMovieDataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: reviewedMovieCollectionView) { collectionView, indexPath, movieId in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistaration, for: indexPath, item: movieId)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems(Array(0...25))
        reviewedMovieDataSource.apply(snapshot)
    }
}

extension MyViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        starRatingView.fillterView.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(MovieDetailViewController(), animated: true)
    }
}

#Preview {
    MyViewController()
}
