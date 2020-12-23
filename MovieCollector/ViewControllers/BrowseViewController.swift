//
//  ViewController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/22/20.
//

import UIKit

class BrowseViewController: UINavigationController {
    
    var popularMoviesData:[Movie] = [] {
        didSet {
            posterImageTest.updateMovieDetailsWith(movie: self.popularMoviesData[0])
        }
    }
    
    var posterImageTest:PosterIconView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
        APIConnect().getPopularMovies(languge: "en-US", region: "") { (returnData) in
            self.popularMoviesData = returnData.movies
//            print(self.popularMoviesData[0].posterPath)
        }
        
        posterImageTest = PosterIconView.init(frame: CGRect.init(x: 50, y: 50, width: 200, height: 300))
        view.addSubview(posterImageTest)
    }

}

