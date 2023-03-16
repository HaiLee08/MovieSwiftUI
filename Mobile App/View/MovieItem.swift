//
//  MovieItem.swift
//  Mobile App
//
//  Created by Hai Le on 3/16/23.
//

import SwiftUI

struct MovieItem: View {
    let movie: Movie
    var body: some View {
        VStack {
            AsyncImage(url: movie.post) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(16.0)
             } else if phase.error != nil {
                 // Indicates an error.
                 Color.red
                 .frame(minHeight: 150)
             } else {
                 ProgressView()
             }
            }
            HStack {
                Text(movie.title)
                    .frame(height: 50)
                Spacer()
                Text(movie.year)
            }
        }
    }
}
