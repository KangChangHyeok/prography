//
//  ViewController.swift
//  prography
//
//  Created by kangChangHyeok on 17/02/2025.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private var bannerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: bannerCollectionViewLayout()).configure {
        <#code#>
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

//    func nowPlayingMovies() {
//        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
//        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
//        let queryItems: [URLQueryItem] = [
//          URLQueryItem(name: "language", value: "ko-KR"),
//          URLQueryItem(name: "page", value: "1"),
//        ]
//        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
//
//        var request = URLRequest(url: components.url!)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 10
//        request.allHTTPHeaderFields = [
//          "accept": "application/json",
//          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YmZiZjIwYzI2MmE4NDdhYTRlNzNhNTUxM2JkOThhNSIsIm5iZiI6MTczOTc1NDAwNy40NDk5OTk4LCJzdWIiOiI2N2IyOGExN2U1ZTFhN2VkN2NlMGYxMjkiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.cm8VPvvj7LVb3Oby8L09E9pBsBQme8jR9LoHPPo-o3Y"
//        ]
//
//        Task {
//            let (data, _) = try await URLSession.shared.data(for: request)
//            print(String(decoding: data, as: UTF8.self))
//        }
//    }
}

private extension HomeViewController {

    func bannerCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(316), heightDimension: .absolute(205))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func setDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CommentCVCell, Comments.Comment.ID> { [weak self] cell, _, commentID in
            guard let comment = self?.viewModel.state.comments?[commentID] else { return }
            cell.bind(comment: comment, viewModel: self?.viewModel)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Comments.Comment.ID>(collectionView: commentCollectionView) { collectionView, indexPath, magazine in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: magazine)
        }
    }
}

#Preview {
    HomeViewController()
}
