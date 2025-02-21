//
//  EndPoint.swift
//  prography
//
//  Created by kangChangHyeok on 21/02/2025.
//

import Foundation

struct EndPoint {
    static let baseURL = "https://api.themoviedb.org/3/movie/"
    
    static let nowPlayingMovies = EndPoint.baseURL + "now_playing"
    static let popularMovies = EndPoint.baseURL + "popular"
    static let topRatedMovies = EndPoint.baseURL + "top_rated"
}
