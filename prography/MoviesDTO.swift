//
//  MoviesDTO.swift
//  prography
//
//  Created by kangChangHyeok on 20/02/2025.
//

import Foundation

// MARK: - MoviesDTO
struct MoviesDTO: Codable {
    let dates: Dates?
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    func toBackDrop() -> [Backdrop] {
        results.map { Backdrop(path: $0.backdropPath, title: $0.title, overView: $0.overview, movieID: $0.id) }
    }
    
    func toMovie() -> [Movie] {
        results.map {
            let genres = $0.genreIDS.map { getGenreName(by: $0) }
            return Movie(movieID: $0.id, posterImagePath: $0.posterPath, overView: $0.overview, title: $0.title, genres: genres, voteAverage: $0.voteAverage)
        }
    }
    
    func getGenreName(by id: Int) -> String {
        switch id {
        case 28: return "액션"
        case 12: return "모험"
        case 16: return "애니메이션"
        case 35: return "코미디"
        case 80: return "범죄"
        case 99: return "다큐멘터리"
        case 18: return "드라마"
        case 10751: return "가족"
        case 14: return "판타지"
        case 36: return "역사"
        case 27: return "공포"
        case 10402: return "음악"
        case 9648: return "미스터리"
        case 10749: return "로맨스"
        case 878: return "SF"
        case 10770: return "TV 영화"
        case 53: return "스릴러"
        case 10752: return "전쟁"
        case 37: return "서부"
        default: return "알 수 없는 장르"
        }
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String
}

// MARK: - Result
struct Result: Codable, Hashable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct Backdrop: Hashable {
    let path: String
    let title: String
    let overView: String
    let movieID: Int
}

struct Movie: Hashable, Identifiable {
    let id = UUID()
    let movieID: Int
    let posterImagePath: String
    let overView: String
    let title: String
    let genres: [String]
    let voteAverage: Double
}
