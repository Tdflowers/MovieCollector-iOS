//
//  APIConnect.swift
//  BingeCheck
//
//  Created by Tyler Flowers on 3/10/19.
//  Copyright © 2019 Tyler Flowers. All rights reserved.
//

import UIKit
import Foundation

class APIConnect: NSObject {
    
    
    func getPopularMovies(languge: String, region: String, completion: @escaping (PopularMovieResults) -> ()) {
        
        let urlString = APIBASEURL + "/movie/popular"
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY)]
        let request = URLRequest(url: urlComponents!.url!)
//        request.httpMethod = "GET"
//        request.setValue("3cb495ce6b77a9608b0188efdf9c9e05", forHTTPHeaderField: "api_key")
//        print(request.allHTTPHeaderFields)
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
            // APIs usually respond with the data you just sent in your POST request
            if let data = responseData, let _ = String(data: data, encoding: .utf8) {
                do {
                    let moviesResults = try JSONDecoder().decode(PopularMovieResults.self, from: data)
                    completion(moviesResults)
                } catch let error {
                    print(error as? Any)
                }
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
        
    }
 
}
