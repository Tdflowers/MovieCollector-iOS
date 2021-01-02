//
//  Movie.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/22/20.
//

import Foundation

struct Movie: Equatable {

    let id: Int64?
    let title: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let adult: Bool?
    let genreIds:[Int64?]?
    let popularity:Float?
    let voteCount:Int64?
    let video:Bool?
    let voteAverage:Float?
    let backdropPath:String?
    let originalTitle:String?
    let originalLanguage:String?
    let runtime:Double?
    
}

extension Movie: Codable {

    enum CodingKeys: String, CodingKey {
        case id, title, overview, adult, popularity, video, runtime
        case posterPath  = "poster_path"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIds = "genre_ids"
        case backdropPath = "backdrop_path"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
    }

    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(Movie.self, from: data) else { return nil }
        self = me
    }
}
