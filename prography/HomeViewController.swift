//
//  ViewController.swift
//  prography
//
//  Created by kangChangHyeok on 17/02/2025.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private lazy var bannerCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: bannerCollectionViewLayout()
    ).configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
    }
    
    private var bannerDataSource: UICollectionViewDiffableDataSource<Int, Int>!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        configureDataSource()
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapShot.appendSections([0])
        snapShot.appendItems(Array(0..<5))
        bannerDataSource.apply(snapShot, animatingDifferences: false)
    }
}

private extension HomeViewController {
    
    func configureLayout() {
        view.addSubview(bannerCollectionView)
        let bannerCollectionViewLayoutConstraints: [NSLayoutConstraint] = [
            bannerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bannerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerCollectionView.heightAnchor.constraint(equalToConstant: 221)
        ]
        NSLayoutConstraint.activate(bannerCollectionViewLayoutConstraints)
    }

    func bannerCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(316), heightDimension: .absolute(205))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        section.interGroupSpacing = 8
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<BannerCell, Int> { cell, _, commentID in
            cell.bind(title: "Title", description: "Description")
        }
        
        bannerDataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: bannerCollectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
}

#Preview {
    HomeViewController()
}
