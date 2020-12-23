//
//  ViewController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/22/20.
//

import UIKit

class BrowseViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
        APIConnect().getPopularMovies(languge: "en-US", region: "") { (returnData) in
            for movie in returnData.movies {
                if let title = movie.title {
                    print(title)
                }
            }
        }
    }


}

