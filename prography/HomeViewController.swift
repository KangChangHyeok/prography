//
//  ViewController.swift
//  prography
//
//  Created by kangChangHyeok on 17/02/2025.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private lazy var containerScrollView = UIScrollView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var containerStackView = UIStackView(arrangedSubviews: [bannerCollectionView, categoryTabBar]).configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private lazy var bannerCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: bannerCollectionViewLayout()
    ).configure {
        $0.bounces = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
    }
    
    private var bannerDataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
    private lazy var categoryTabBar = CategoryTabBar().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.nowPlayingButton.addTarget(self, action: #selector(CategoryButtonDidTap), for: .touchUpInside)
        $0.popularButton.addTarget(self, action: #selector(CategoryButtonDidTap), for: .touchUpInside)
        $0.topRatedButton.addTarget(self, action: #selector(CategoryButtonDidTap), for: .touchUpInside)
    }
    
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
        view.addSubview(containerScrollView)
        
        let containerScrolLViewLayoutConstraints: [NSLayoutConstraint] = [
            containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            containerScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        containerScrollView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate(containerScrolLViewLayoutConstraints)
        
        let containerStackViewLayoutConstraints: [NSLayoutConstraint] = [
            containerStackView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: containerScrollView.contentLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: containerScrollView.contentLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            containerStackView.widthAnchor.constraint(equalToConstant: view.frame.width - 32)
            
        ]
        
        NSLayoutConstraint.activate(containerStackViewLayoutConstraints)
        
        let bannerCollectionViewLayoutConstraints: [NSLayoutConstraint] = [
            bannerCollectionView.heightAnchor.constraint(equalToConstant: 221)
        ]
        NSLayoutConstraint.activate(bannerCollectionViewLayoutConstraints)
        
        let categoryTabBarLayoutConstraints: [NSLayoutConstraint] = [
            categoryTabBar.heightAnchor.constraint(equalToConstant: 64)
        ]
        NSLayoutConstraint.activate(categoryTabBarLayoutConstraints)
    }

    func bannerCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(316), heightDimension: .absolute(205))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 8, leading: 0, bottom: 8, trailing: 0)
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
    
    @objc func CategoryButtonDidTap(sender: UIButton) {
        [ categoryTabBar.nowPlayingButton, categoryTabBar.popularButton, categoryTabBar.topRatedButton].forEach {
            guard $0 === sender else {
                $0.isSelected = false
                return
            }
            $0.isSelected = true
        }
        NSLayoutConstraint.deactivate(self.categoryTabBar.highLightBarConstraints ?? [])
        guard let titleLabel = sender.titleLabel else { return }
        let senderPosition = view.convert(titleLabel.frame, from: categoryTabBar)
        let constraints: [NSLayoutConstraint] = [
            categoryTabBar.highlightBar.bottomAnchor.constraint(equalTo: categoryTabBar.bottomAnchor, constant: -10),
            categoryTabBar.highlightBar.heightAnchor.constraint(equalToConstant: 3),
            categoryTabBar.highlightBar.centerXAnchor.constraint(equalTo: sender.centerXAnchor),
            categoryTabBar.highlightBar.widthAnchor.constraint(equalToConstant: senderPosition.width - 4)
        ]
        NSLayoutConstraint.activate(constraints)
        self.categoryTabBar.highLightBarConstraints = constraints
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

#Preview {
    HomeViewController()
}
