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
    
    // MARK: - Properties

   private static var sharedAPIConnect: APIConnect = {
    let apiConnect = APIConnect(baseURL: APIBASEURL)

       // Configuration
       // ...

       return apiConnect
   }()

   // MARK: -

   let baseURL: String
    let cache = Cache<Int64, Movie>()
   // Initialization

   private init(baseURL: String) {
       self.baseURL = baseURL
   }

   // MARK: - Accessors

   class func shared() -> APIConnect {
       return sharedAPIConnect
   }

        
    func getPopularMovies(languge: String, region: String, completion: @escaping (PopularMovieResults) -> ()) {
        
        let urlString = APIBASEURL + "/movie/popular"
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY), URLQueryItem(name: "languge", value: languge), URLQueryItem(name: "region", value: region)]
        let request = URLRequest(url: urlComponents!.url!)
        print(request)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
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
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
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
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
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
    
    func getSearchResults(languge: String, region: String, query: String, page: String,completion: @escaping (MovieSearchResults) -> ()) {
        
        let urlString = APIBASEURL + "/search/movie"
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY), URLQueryItem(name: "languge", value: languge), URLQueryItem(name: "region", value: region), URLQueryItem(name: "page", value: page), URLQueryItem(name: "query", value: query)]
        let request = URLRequest(url: urlComponents!.url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
            if let data = responseData, let _ = String(data: data, encoding: .utf8) {
                do {
                    let movieSearchResults = try JSONDecoder().decode(MovieSearchResults.self, from: data)
                    completion(movieSearchResults)
                } catch let error {
                    print(error as Any)
                }
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    func getMovieDetailsFor(id: Int64, completion: @escaping (Movie) -> ()) {
        let idString = String(id)
        let urlString = APIBASEURL + "/movie/" + idString
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY)]
        let request = URLRequest(url: urlComponents!.url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
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
    
    func getMovieCreditsFor(id: Int64, completion: @escaping (Credits) -> ()) {
        let idString = String(id)
        
        let urlString = APIBASEURL + "/movie/" + idString + "/credits"
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY)]
        let request = URLRequest(url: urlComponents!.url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
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
