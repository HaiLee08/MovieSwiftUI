//
//  Movie.swift
//  Mobile App
//
//  Created by Hai Le on 3/15/23.
//

import Foundation

struct Movie: Identifiable {
    let id: String
    let title: String
    let year: String
    let type: String
    let post: URL
}

extension Movie: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case post = "Poster"
    }
}
