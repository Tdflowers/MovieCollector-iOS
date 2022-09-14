//
//  Profile.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 9/14/22.
//

import Foundation

struct UserProfile: Equatable {

    let name: String
    let username: String
    let email: String
    
}

extension UserProfile: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name, username, email
    }
    
    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(UserProfile.self, from: data) else { return nil }
        self = me
    }
}
