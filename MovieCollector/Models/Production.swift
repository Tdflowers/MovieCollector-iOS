//
//  TVSeason.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 5/13/22.
//

import Foundation

struct ProductionCompany : Equatable {
    let id: Int64?
    let name:String?
    let logoPath:String?
    let originCountry:String?
}

extension ProductionCompany : Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
    
    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(ProductionCompany.self, from: data) else { return nil }
            self = me
    }
}

struct ProductionCountry : Equatable {
    let iso3166_1 :String?
    let name : String?
}

extension ProductionCountry : Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case iso3166_1 = "iso_3166_1"
    }
    
    
    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(ProductionCountry.self, from: data) else { return nil }
            self = me
    }
}

struct SpokenLanguage : Equatable {
    let iso_639_1 :String?
    let name : String?
    let englishName: String?
}

extension SpokenLanguage : Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case iso_639_1 = "iso_639_1"
        case englishName = "english_name"
    }
    
    
    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(SpokenLanguage.self, from: data) else { return nil }
            self = me
    }
}
