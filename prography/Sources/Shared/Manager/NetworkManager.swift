//
//  NetworkManager.swift
//  prography
//
//  Created by kangChangHyeok on 21/02/2025.
//

import Foundation

struct NetworkManager {
    static let shared = NetworkManager()
    
    func request<T: Codable>(endPoint: String, query: [URLQueryItem]) async throws -> T {
        let url = URL(string: endPoint)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        components.queryItems = components.queryItems.map { $0 + query } ?? query

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YmZiZjIwYzI2MmE4NDdhYTRlNzNhNTUxM2JkOThhNSIsIm5iZiI6MTczOTc1NDAwNy40NDk5OTk4LCJzdWIiOiI2N2IyOGExN2U1ZTFhN2VkN2NlMGYxMjkiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.cm8VPvvj7LVb3Oby8L09E9pBsBQme8jR9LoHPPo-o3Y"
        ]
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(T.self, from: data)
        return response
    }
}
