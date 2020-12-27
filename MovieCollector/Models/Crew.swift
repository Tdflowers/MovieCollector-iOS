//
//  Crew.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/27/20.
//

import Foundation
struct Crew {
    
    let adult: Bool?
    let gender: Double?
    let id: Double?
    let knownForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let department:String?
    let creditId:String?
    let job:String?
    
}

extension Crew: Decodable {

    enum CodingKeys: String, CodingKey {
        case adult, gender, id, name, popularity, department, job
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case profilePath = "profile_path"
        case creditId = "credit_id"
    }

    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(Crew.self, from: data) else { return nil }
        self = me
    }
}

