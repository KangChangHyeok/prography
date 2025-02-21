//
//  HomeViewModel.swift
//  prography
//
//  Created by kangChangHyeok on 20/02/2025.
//

import Foundation
import Combine

//MARK: - Input

enum HomeViewModelInput {
    case viewDidLoad
    case scrolledPage(Int)
    case categoryButtonDidTap(Int)
    case scrollToBottom(Int)
    case backdropImageDidTap(Int, Int)
    case movieSelected(Int, Int)
}

//MARK: - Action

enum HomeViewModelAction {
    case fetchNowPlayingMovies(Int)
    case fetchPopularMovies(Int)
    case fetchTopRatedMovies(Int)
    case fetchSelectedCategoryMoviesBackdrop(Int)
    case showMovieDetailViewController(Int)
}

//MARK: - State

final class HomeViewModelState {
    
    @Published var backdrop: [Backdrop] = []
    @Published var nowPlayingMovies: [Movie] = []
    @Published var popularMovies: [Movie] = []
    @Published var topRatedMovies: [Movie] = []
    @Published var showMovieDetailViewController: Int?
    
    fileprivate var nowPlayingMoviesPage = 1
    fileprivate var popularMoviesPage = 1
    fileprivate var topRatedMoviesPage = 1
    
    fileprivate var nowPlayingMovieBackdrops: [Backdrop] = []
    fileprivate var popularMovieBackdrops: [Backdrop] = []
    fileprivate var topRatedMovieBackdrops: [Backdrop] = []
}

//MARK: - ViewModel

final class HomeViewModel: ViewModelProtocol {
    
    typealias Input = HomeViewModelInput
    typealias Action = HomeViewModelAction
    typealias State = HomeViewModelState
    
    //MARK: - Transform
    
    var state: HomeViewModelState = .init()
    
    func transform(_ input: Input) -> [Action] {
        switch input {
        case .viewDidLoad:
            return [.fetchNowPlayingMovies(state.nowPlayingMoviesPage), .fetchPopularMovies(state.popularMoviesPage), .fetchTopRatedMovies(state.topRatedMoviesPage)]
        case .scrolledPage(let index):
            return [.fetchSelectedCategoryMoviesBackdrop(index)]
        case .categoryButtonDidTap(let index):
            return [.fetchSelectedCategoryMoviesBackdrop(index)]
        case .scrollToBottom(let index):
            switch index {
            case 0: return [.fetchNowPlayingMovies(state.nowPlayingMoviesPage)]
            case 1: return [.fetchPopularMovies(state.popularMoviesPage)]
            case 2: return [.fetchTopRatedMovies(state.topRatedMoviesPage)]
            default: return [.fetchNowPlayingMovies(state.popularMoviesPage)]
            }
        case .movieSelected(let pageTag, let index):
            switch pageTag {
            case 0: return [ .showMovieDetailViewController(state.nowPlayingMovies[index].movieID)]
            case 1: return [ .showMovieDetailViewController(state.popularMovies[index].movieID)]
            case 2: return [ .showMovieDetailViewController(state.topRatedMovies[index].movieID)]
            default: return [ .showMovieDetailViewController(state.nowPlayingMovies[index].movieID)]
            }
            
        case .backdropImageDidTap(let pageTag, let index):
            switch pageTag {
            case 0: return [ .showMovieDetailViewController(state.nowPlayingMovieBackdrops[index].movieID)]
            case 1: return [ .showMovieDetailViewController(state.popularMovieBackdrops[index].movieID)]
            case 2: return [ .showMovieDetailViewController(state.topRatedMovieBackdrops[index].movieID)]
            default: return [ .showMovieDetailViewController(state.nowPlayingMovies[index].movieID)]
            }
        }
    }
    
    //MARK: - Perform
    
    func perform(_ action: Action) {
        switch action {
        case .fetchNowPlayingMovies(let page):
            Task {
                let dto: MoviesDTO = try await NetworkManager.shared.request(
                    endPoint: EndPoint.nowPlayingMovies,
                    query: [
                    URLQueryItem(name: "language", value: "ko-KR"),
                    URLQueryItem(name: "page", value: page.description),
                  ]
                )
                
                state.nowPlayingMovies.append(contentsOf: dto.toMovie())
                if state.nowPlayingMoviesPage == 1 {
                    state.backdrop = dto.toBackDrop()
                    state.nowPlayingMovieBackdrops = dto.toBackDrop()
                }
                
                state.nowPlayingMoviesPage += 1
            }

        case .fetchPopularMovies(let page):
            
            Task {
                let dto: MoviesDTO = try await NetworkManager.shared.request(
                    endPoint: EndPoint.popularMovies,
                    query: [
                    URLQueryItem(name: "language", value: "ko-KR"),
                    URLQueryItem(name: "page", value: page.description),
                  ]
                )
                
                state.popularMovies.append(contentsOf: dto.toMovie())
                if state.popularMoviesPage == 1 {
                    state.popularMovieBackdrops = dto.toBackDrop()
                }
                
                state.popularMoviesPage += 1
            }
        case .fetchTopRatedMovies(let page):
            
            Task {
                let dto: MoviesDTO = try await NetworkManager.shared.request(
                    endPoint: EndPoint.topRatedMovies,
                    query: [
                    URLQueryItem(name: "language", value: "ko-KR"),
                    URLQueryItem(name: "page", value: page.description),
                  ]
                )
                
                state.topRatedMovies.append(contentsOf: dto.toMovie())
                if state.topRatedMoviesPage == 1 {
                    state.topRatedMovieBackdrops = dto.toBackDrop()
                }
                
                state.topRatedMoviesPage += 1
            }
            
        case .fetchSelectedCategoryMoviesBackdrop(let index):
            switch index {
            case 0:
                state.backdrop = state.nowPlayingMovieBackdrops
            case 1:
                state.backdrop = state.popularMovieBackdrops
            case 2:
                state.backdrop = state.topRatedMovieBackdrops
            default: break
            }
        case .showMovieDetailViewController(let index):
            state.showMovieDetailViewController = index
        }
    }
}
