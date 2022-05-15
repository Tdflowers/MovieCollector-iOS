//
//  Credits.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/27/20.
//

import Foundation

struct Credits {

    let id: Double?
    let cast: [Cast]?
    let crew: [Crew]?
}

extension Credits: Codable {

    enum CodingKeys: String, CodingKey {
        case id, cast, crew
    }

    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(Credits.self, from: data) else { return nil }
        self = me
    }
}
