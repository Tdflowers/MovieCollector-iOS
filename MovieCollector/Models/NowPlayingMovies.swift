//
//  NowPlayingMovies.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/23/20.
//

import Foundation

struct NowPlayingMovies {
    
    let movies: [Movie]
}

extension NowPlayingMovies: Decodable {

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }

    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(NowPlayingMovies.self, from: data) else { return nil }
        self = me
    }
}
