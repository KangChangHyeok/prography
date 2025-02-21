//
//  MyViewModel.swift
//  prography
//
//  Created by kangChangHyeok on 21/02/2025.
//

import Foundation
import Combine

//MARK: - Input

enum MyViewModelInput {
    case viewWillAppear
    case selectedMovie(Int)
    case selectedFillter(Int)
}

//MARK: - Action

enum MyViewModelAction {
    case fetchReviews
    case showMovieDetailViewController(Int)
    case filterReviews(Int)
}

//MARK: - State

final class MyViewModelState {
    
    @Published var reviews: [Review] = []
    @Published var fillterReviews: [Review] = []
    @Published var showMovieDetailViewController: Int?
}

//MARK: - ViewModel

final class MyViewModel: ViewModelProtocol {
    
    typealias Input = MyViewModelInput
    typealias Action = MyViewModelAction
    typealias State = MyViewModelState
    
    var state: MyViewModelState = .init()
    
    //MARK: - Transform
    
    func transform(_ input: Input) -> [Action] {
        switch input {
        case .viewWillAppear: [.fetchReviews]
        case .selectedMovie(let index): [.showMovieDetailViewController(index)]
        case .selectedFillter(let starRate): [.filterReviews(starRate)]
        }
    }
    
    //MARK: - Perform
    
    func perform(_ action: Action) {
        switch action {
        case .fetchReviews:
            guard let reviews = CoreDataManager.shared.fetchReviews() else { return }
            
            guard state.fillterReviews.isEmpty else {
                return
            }
            state.reviews = reviews
            state.fillterReviews = reviews
        case .showMovieDetailViewController(let index):
            state.showMovieDetailViewController = Int(state.fillterReviews[index].movieID)
        case .filterReviews(let starRate):
            if starRate == -1 {
                state.fillterReviews = state.reviews
            } else {
                
                state.fillterReviews = state.reviews.filter {
                    print($0)
                    return $0.rate == starRate
                }
            }
        }
    }
}
