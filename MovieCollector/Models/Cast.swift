//
//  Person.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/27/20.
//

import Foundation

struct Cast {
    
    let adult: Bool?
    let gender: Double?
    let id: Double?
    let knownForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castId:Double?
    let character:String?
    let creditId:String?
    let order:Double?
    
}

extension Cast: Codable {

    enum CodingKeys: String, CodingKey {
        case adult, gender, id, name, popularity, character, order
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case profilePath = "profile_path"
        case castId = "cast_id"
        case creditId = "credit_id"
    }

    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(Cast.self, from: data) else { return nil }
        self = me
    }
}

