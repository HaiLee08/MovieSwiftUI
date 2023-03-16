//
//  OmdbapiClient.swift
//  Mobile App
//
//  Created by Hai Le on 3/15/23.
//

import Foundation

struct SearchMovies: Decodable {
    let search: [Movie]
    let totalResults: String
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

class OmdbapiClient: NetworkClient {
    static let numbersItemsOfPage = 10
    private let apikey = "b9bd48a6"
    
    ///request: https://www.omdbapi.com?apikey=b9bd48a6&s=Marvel&type=movie
    func fetchMovie(searchQuery: String, page: Int) async throws -> [Movie] {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "apikey", value: apikey),
            URLQueryItem(name: "type", value: "movie"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "s", value: searchQuery)
        ]
        let outcome = try await self.get("", queryItems: queryItems)
        switch outcome {
        case .success(let result):
            let decoder = JSONDecoder()
            do {
                let searchResult = try decoder.decode(SearchMovies.self, from: result.data)
                guard searchResult.response == "True" else { return  [] }
                return searchResult.search
            } catch let error {
                throw error
            }
        case .failure(let error):
            throw error
        }
    }
}

let apiClient = OmdbapiClient(hostname: "www.omdbapi.com")
