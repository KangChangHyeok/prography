//
//  MovieDetailViewModle.swift
//  prography
//
//  Created by kangChangHyeok on 21/02/2025.
//

import Foundation

import Foundation
import Combine
import CoreData

//MARK: - Input

enum MovieDetailViewModelInput {
    case viewDidLoad
    case editButtonDidTap
    case deleteButtonDidTap
}

//MARK: - Action

enum MovieDetailViewModelAction {
    case fetchMovieDetail
    case fetchMovieReview
    case editReview
    case deleteReview
}

//MARK: - State

final class MovieDetailsViewModelState {
    
    @Published var editReview: Void = ()
    @Published var movieDetail: MovieDetailDTO?
    @Published var review: Review?
    @Published var successDeleteReview: Void = ()
    
    var movieID: Int
    
    init(movieID: Int) {
        self.movieID = movieID
    }
}

//MARK: - ViewModel

final class MovieDetailViewModel: ViewModelProtocol {
    
    typealias Input = MovieDetailViewModelInput
    typealias Action = MovieDetailViewModelAction
    typealias State = MovieDetailsViewModelState
    
    var state: MovieDetailsViewModelState
    
    init(movieID: Int) {
        state = .init(movieID: movieID)
    }
    
    //MARK: - Transform
    
    func transform(_ input: Input) -> [Action] {
        switch input {
        case .viewDidLoad: [.fetchMovieDetail, .fetchMovieReview]
        case .editButtonDidTap:
            [.editReview]
        case .deleteButtonDidTap:
            [.deleteReview]
        }
    }
    
    //MARK: - Perform
    
    func perform(_ action: Action) {
        switch action {
        case .fetchMovieDetail:
            let url = URL(string: EndPoint.baseURL + state.movieID.description)!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "language", value: "ko-KR")
            ]
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
                "accept": "application/json",
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YmZiZjIwYzI2MmE4NDdhYTRlNzNhNTUxM2JkOThhNSIsIm5iZiI6MTczOTc1NDAwNy40NDk5OTk4LCJzdWIiOiI2N2IyOGExN2U1ZTFhN2VkN2NlMGYxMjkiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.cm8VPvvj7LVb3Oby8L09E9pBsBQme8jR9LoHPPo-o3Y"
            ]
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(for: request)
                    let dto = try JSONDecoder().decode(MovieDetailDTO.self, from: data)
                    state.movieDetail = dto
                } catch {
                    print(error)
                }
            }
        case .fetchMovieReview:
            let fetchRequest: NSFetchRequest<Review> = Review.fetchRequest()
            let predicate = NSPredicate(format: "movieID == %d", Int64(state.movieID))
            fetchRequest.predicate = predicate
            
            do {
                let reviews = try CoreDataManager.shared.context.fetch(fetchRequest)
                print("✅ \(state.movieID)에 해당하는 리뷰 \(reviews.count)개 가져옴")
                state.review = reviews.first
            } catch {
                print("❌ 리뷰 가져오기 실패: \(error)")
            }
        case .editReview:
            state.editReview = ()
        case .deleteReview:
            CoreDataManager.shared.deleteReview(movieID: state.movieID)
            state.successDeleteReview = ()
        }
    }
}
