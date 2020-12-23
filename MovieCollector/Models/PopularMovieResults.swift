//
//  Popular.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/22/20.
//

import Foundation
/// Data structure for movies search results.
struct PopularMovieResults {
    
    let movies: [Movie]
}

extension PopularMovieResults: Decodable {

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }

    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(PopularMovieResults.self, from: data) else { return nil }
        self = me
    }
}
