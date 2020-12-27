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
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY), URLQueryItem(name: "languge", value: languge), URLQueryItem(name: "region", value: region)]
        let request = URLRequest(url: urlComponents!.url!)
        
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
                    print(error as Any)
                }
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    func getNowPlayingMovies(languge: String, region: String, completion: @escaping (NowPlayingMovies) -> ()) {
        
        let urlString = APIBASEURL + "/movie/now_playing"
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY), URLQueryItem(name: "languge", value: languge), URLQueryItem(name: "region", value: region)]
        let request = URLRequest(url: urlComponents!.url!)
        
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
                    let moviesResults = try JSONDecoder().decode(NowPlayingMovies.self, from: data)
                    completion(moviesResults)
                } catch let error {
                    print(error as Any)
                }
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(languge: String, region: String, completion: @escaping (UpcomingMovies) -> ()) {
        
        let urlString = APIBASEURL + "/movie/upcoming"
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY), URLQueryItem(name: "languge", value: languge), URLQueryItem(name: "region", value: region)]
        let request = URLRequest(url: urlComponents!.url!)
        
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
                    let moviesResults = try JSONDecoder().decode(UpcomingMovies.self, from: data)
                    completion(moviesResults)
                } catch let error {
                    print(error as Any)
                }
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    func getMovieDetailsFor(id: String, completion: @escaping (Movie) -> ()) {
        
        let urlString = APIBASEURL + "/movie/" + id
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY)]
        let request = URLRequest(url: urlComponents!.url!)
        
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
                    let moviesResults = try JSONDecoder().decode(Movie.self, from: data)
                    completion(moviesResults)
                } catch let error {
                    print(error as Any)
                }
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    func getMovieCreditsFor(id: String, completion: @escaping (Credits) -> ()) {
        
        let urlString = APIBASEURL + "/movie/" + id + "/credits"
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY)]
        let request = URLRequest(url: urlComponents!.url!)
        
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
                    let moviesResults = try JSONDecoder().decode(Credits.self, from: data)
                    completion(moviesResults)
                } catch let error {
                    print(error as Any)
                }
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
 
 
}
