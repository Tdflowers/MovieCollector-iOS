//
//  SearchResults.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 1/2/21.
//

import Foundation

struct MovieSearchResults {
    
    let movies: [Movie]
    let totalPages: Double
    let totalResults: Double
    let page: Int64
}

extension MovieSearchResults: Decodable {

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(MovieSearchResults.self, from: data) else { return nil }
        self = me
    }
}
