//
//  JSDecoder+.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/22/20.
//

import Foundation

extension JSONDecoder {

    /// Default JSON Decoder for The Movies DB.
    static let theMovieDB: JSONDecoder = {
        let decoder = JSONDecoder()
        
        return decoder
    }()
}
