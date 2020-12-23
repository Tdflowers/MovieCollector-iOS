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
            //Did get popular movies
//            updatePopularMoviesView()
        }
    }
    
    var scrollView:UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var stackView:UIStackView = {
        let view = UIStackView()

        view.axis = .vertical
        view.spacing = 10

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
//    var popularMoviesCollectionView:
    
    var posterIcons:[PosterIconView] = []
    
    var posterImageTest:PosterIconView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white

        self.view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        layoutConstraints()
        
        APIConnect().getPopularMovies(languge: "en-US", region: "") { (returnData) in
            self.popularMoviesData = returnData.movies
        }
    }
    
    func layoutConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    func updatePopularMoviesView () {

        for i in 0...3 {
            DispatchQueue.main.async {
                let posterIcon = PosterIconView.init()
                posterIcon.translatesAutoresizingMaskIntoConstraints = false
                self.stackView.addArrangedSubview(posterIcon)
                posterIcon.updateMovieDetailsWith(movie: self.popularMoviesData[i])
            }
        }
    }

}

