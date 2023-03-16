//
//  ContentView.swift
//  Mobile App
//
//  Created by Hai Le on 3/15/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State var wholeSize: CGSize = .zero
    @State var scrollViewSize: CGSize = .zero
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let spaceName = "scroll"

    var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.textSearchBar, placeholderText: viewModel.placeholderSearchBar, onCommit: {
                Task {
                    viewModel.resetSearchBar()
                    try? await viewModel.fetchMovies()
                }
            }) {
                
            }
            ChildSizeReader(size: $wholeSize) {
                ScrollView {
                    ChildSizeReader(size: $scrollViewSize) {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(viewModel.movies) { movie in
                                MovieItem(movie: movie)
                            }
                        }
                        .padding(.horizontal)
                        .background(
                            GeometryReader { proxy in
                                Color.clear.preference(
                                    key: ViewOffsetKey.self,
                                    value: -1 * proxy.frame(in: .named(spaceName)).origin.y
                                )
                            }
                        )
                        .onPreferenceChange(
                            ViewOffsetKey.self,
                            perform: { value in
                                if value >= scrollViewSize.height - wholeSize.height {
                                    Task {
                                        try? await viewModel.fetchMovies()
                                    }
                                }
                            }
                        )
                    }
                }
                .coordinateSpace(name: spaceName)
            }
            .onChange(
                of: scrollViewSize,
                perform: { value in
                    
                }
            )
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
