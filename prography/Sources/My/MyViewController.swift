//
//  MyViewController.swift
//  prography
//
//  Created by kangChangHyeok on 17/02/2025.
//

import UIKit
import Combine

final class MyViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: MyViewModel
    private var cancelables = Set<AnyCancellable>()
    
    private var reviewedMovieDataSource: UICollectionViewDiffableDataSource<Int, Review>!
    
    // MARK: - UI
    
    private lazy var starRatingView = StarRatingView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bind(viewModel: self.viewModel)
    }
    
    private lazy var reviewedMovieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createReviewedMovieCollectionViewLayout()).configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
    }
    
    // MARK: - Initializer
    
    init(viewModel: MyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        configure()
        configureLayout()
        configureDataSource()
        bindStates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        viewModel.send(.viewWillAppear)
    }
    
    // MARK: - Bind
    
    private func bindStates() {
        
        viewModel.state.$showMovieDetailViewController
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movieID in
                guard let movieID else { return }
                let viewModel = MovieDetailViewModel(movieID: movieID)
                let viewController = MovieDetailViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: &cancelables)
        
        viewModel.state.$fillterReviews
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reviews in
                var snapShot = NSDiffableDataSourceSnapshot<Int, Review>()
                snapShot.appendSections([0])
                snapShot.appendItems(reviews)
                self?.reviewedMovieDataSource.apply(snapShot)
            }
            .store(in: &cancelables)
    }
}

// MARK: - Helper

private extension MyViewController {
    
    func configure() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
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
        let cellRegistaration = UICollectionView.CellRegistration<ReviewedMovieCell, Review> { cell, indexPath, review in
            cell.bind(review)
        }
        
        reviewedMovieDataSource = UICollectionViewDiffableDataSource<Int, Review>(collectionView: reviewedMovieCollectionView) { collectionView, indexPath, movieId in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistaration, for: indexPath, item: movieId)
        }
    }
}

extension MyViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        starRatingView.fillterView.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.send(.selectedMovie(indexPath.row))
    }
}


