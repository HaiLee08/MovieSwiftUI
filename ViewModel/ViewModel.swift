//
//  ViewModel.swift
//  Mobile App
//
//  Created by Hai Le on 3/15/23.
//

import SwiftUI

class ViewModel: NSObject, ObservableObject {
    @Published var movies: [Movie] = [Movie]()
    @Published var isLoading: Bool = false
    @Published var textSearchBar: String = "Marvel"
    var placeholderSearchBar: String = "Search Movie"
    var page = 1;
    var isLoadMore: Bool = true
    
    @MainActor
    func fetchMovies() async throws {
        guard self.isLoadMore && !self.isLoading else { return }
        self.isLoading = true
        let movies = try await apiClient.fetchMovie(searchQuery: textSearchBar, page: page)
        self.isLoading = false
        self.movies.append(contentsOf: movies)
        if movies.count == OmdbapiClient.numbersItemsOfPage {
            self.page += 1;
            self.isLoadMore = true
        } else {
            self.isLoadMore = false
        }
    }
    
    func resetSearchBar() {
        self.isLoading = false
        self.isLoadMore = true
        self.movies.removeAll()
        self.page = 1
    }
}
