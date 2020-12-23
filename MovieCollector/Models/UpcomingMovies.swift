//
//  UpcomingMovies.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/23/20.
//

import Foundation

struct UpcomingMovies {
    
    let movies: [Movie]
}

extension UpcomingMovies: Decodable {

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }

    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(UpcomingMovies.self, from: data) else { return nil }
        self = me
    }
}
