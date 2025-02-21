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
}

//MARK: - Action

enum HomeViewModelAction {
    case fetchNowPlayingMovies(Int)
    case fetchPopularMovies(Int)
    case fetchTopRatedMovies(Int)
    case fetchSelectedCategoryMoviesBackdrop(Int)
}

//MARK: - State

class HomeViewModelState {
    
    @Published var backdrop: [Backdrop] = []
    @Published var nowPlayingMovies: [Movie] = []
    @Published var popularMovies: [Movie] = []
    @Published var topRatedMovies: [Movie] = []
    
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
        }
    }
    
    //MARK: - Perform
    
    func perform(_ action: Action) {
        switch action {
        case .fetchNowPlayingMovies(let page):
            
            let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            let queryItems: [URLQueryItem] = [
              URLQueryItem(name: "language", value: "ko-KR"),
              URLQueryItem(name: "page", value: page.description),
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
                let (data, _) = try await URLSession.shared.data(for: request)
                let moviesDTO = try JSONDecoder().decode(MoviesDTO.self, from: data)
                
                state.nowPlayingMovies.append(contentsOf: moviesDTO.toMovie())
                if state.nowPlayingMoviesPage == 1 {
                    state.backdrop = moviesDTO.toBackDrop()
                    state.nowPlayingMovieBackdrops = moviesDTO.toBackDrop()
                }
                
                state.nowPlayingMoviesPage += 1
            }
        case .fetchPopularMovies(let page):
            let url = URL(string: "https://api.themoviedb.org/3/movie/popular")!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            let queryItems: [URLQueryItem] = [
              URLQueryItem(name: "language", value: "ko-KR"),
              URLQueryItem(name: "page", value: page.description),
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
                    let moviesDTO = try JSONDecoder().decode(MoviesDTO.self, from: data)
                    state.popularMovies.append(contentsOf: moviesDTO.toMovie())
                    if state.popularMoviesPage == 1 {
                        state.popularMovieBackdrops = moviesDTO.toBackDrop()
                    }
                    state.popularMoviesPage += 1
                } catch {
                    print(error)
                }
                
            }
        case .fetchTopRatedMovies(let page):
            
            let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated")!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            let queryItems: [URLQueryItem] = [
              URLQueryItem(name: "language", value: "ko-KR"),
              URLQueryItem(name: "page", value: page.description),
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
                let (data, _) = try await URLSession.shared.data(for: request)
                let moviesDTO = try JSONDecoder().decode(MoviesDTO.self, from: data)
                
                state.topRatedMovies.append(contentsOf: moviesDTO.toMovie())
                if state.topRatedMoviesPage == 1 {
                    state.topRatedMovieBackdrops = moviesDTO.toBackDrop()
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
        }
    }
}
