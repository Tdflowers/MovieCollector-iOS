//
//  ViewController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/22/20.
//

import UIKit

class BrowseViewController: UIViewController, PosterIconCollectionViewDelegate {
    
    var popularMoviesData:[Movie] = [] {
        didSet {
            //Did get popular movies
            updatePopularMoviesView()
        }
    }
    
    var nowPlayingMoviesData:[Movie] = [] {
        didSet {
            //Did get now playing movies
            updateNowPlayingMoviesView()
        }
    }
    
    var upcomingMoviesData:[Movie] = [] {
        didSet {
            updateUpcomingMoviesView()
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
        view.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)


        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var featuredView:FeaturedMovieView = {
        let view = FeaturedMovieView.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var popularMoviesCollectionView:PosterIconCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = PosterIconCollectionView.init(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.dataSource = view
        view.delegate = view
        view.allowsSelection = true
        view.register(PosterIconView.self, forCellWithReuseIdentifier: "cell")
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return view
    }()
    
    var nowPlayingMoviesCollectionView:PosterIconCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = PosterIconCollectionView.init(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.dataSource = view
        view.delegate = view
        view.allowsSelection = true
        view.register(PosterIconView.self, forCellWithReuseIdentifier: "cell")
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return view
    }()
    
    var upcomingMoviesCollectionView:PosterIconCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = PosterIconCollectionView.init(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.dataSource = view
        view.delegate = view
        view.allowsSelection = true
        view.register(PosterIconView.self, forCellWithReuseIdentifier: "cell")
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return view
    }()
    
    var popularTitleLabel:UILabel = {
        let label = UILabel.init()
        label.text = "Popular Movies"
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)
        return label
    }()
    
    var nowPlayingTitleLabel:UILabel = {
        let label = UILabel.init()
        label.text = "Now Playing"
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)
        return label
    }()
    
    var upcomingTitleLabel:UILabel = {
        let label = UILabel.init()
        label.text = "Upcoming"
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)
        return label
    }()
    
    var featuredTitleLabel:UILabel = {
        let label = UILabel.init()
        label.text = "Featured"
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)
        return label
    }()
    
    var posterIcons:[PosterIconView] = []
    
    var posterImageTest:PosterIconView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .systemBackground
//            .background(Color(UIColor.systemBackground))
        
//        self.setViewControllers(self, animated: true)

        self.view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(featuredTitleLabel)
        stackView.addArrangedSubview(featuredView)
        stackView.addArrangedSubview(popularTitleLabel)
        stackView.addArrangedSubview(popularMoviesCollectionView)
        stackView.addArrangedSubview(nowPlayingTitleLabel)
        stackView.addArrangedSubview(nowPlayingMoviesCollectionView)
        stackView.addArrangedSubview(upcomingTitleLabel)
        stackView.addArrangedSubview(upcomingMoviesCollectionView)
        layoutConstraints()
        
        popularMoviesCollectionView.posterDelegate = self
        nowPlayingMoviesCollectionView.posterDelegate = self
        upcomingMoviesCollectionView.posterDelegate = self
                
        let featuredTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(featuredViewWasTapped))
        featuredTapGesture.numberOfTapsRequired = 1
        featuredView.addGestureRecognizer(featuredTapGesture)
        
        let apiConnect = APIConnect.shared()
       
        apiConnect.getPopularMovies(languge: "en-US", region: "US") { (returnData) in
            self.popularMoviesData = returnData.movies
        }
        apiConnect.getNowPlayingMovies(languge: "en-US", region: "US") { (returnData) in
            self.nowPlayingMoviesData = returnData.movies
        }
        apiConnect.getUpcomingMovies(languge: "en-US", region: "US") { (returnData) in
            self.upcomingMoviesData = returnData.movies
        }
    }
    
    func layoutConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            featuredView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor, multiplier: 0.30),
        ])
        
        NSLayoutConstraint.activate([
            popularMoviesCollectionView.heightAnchor.constraint(greaterThanOrEqualTo: self.scrollView.heightAnchor, multiplier: 0.30),
        ])
        
        NSLayoutConstraint.activate([
            popularTitleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            nowPlayingMoviesCollectionView.heightAnchor.constraint(greaterThanOrEqualTo: self.scrollView.heightAnchor, multiplier: 0.30),
        ])
        
        NSLayoutConstraint.activate([
            nowPlayingTitleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            upcomingMoviesCollectionView.heightAnchor.constraint(greaterThanOrEqualTo: self.scrollView.heightAnchor, multiplier: 0.30),
        ])
        
        NSLayoutConstraint.activate([
            upcomingTitleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
    }
    
    func updatePopularMoviesView () {
        popularMoviesCollectionView.moviesData = popularMoviesData
        featuredView.movie = popularMoviesData.randomElement()
    }
    
    func updateNowPlayingMoviesView() {
        nowPlayingMoviesCollectionView.moviesData = nowPlayingMoviesData
    }
    
    func updateUpcomingMoviesView() {
        upcomingMoviesCollectionView.moviesData = upcomingMoviesData
    }
    
    func posterWasTappedWithMovie(_ movie: Movie) {
//        print(movie)
        let newViewController = MovieDetailViewController()
        newViewController.movie = movie
        newViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func posterWasTappedWithTVSeries(_ series: TVSeries) {
        print("tv series was tapped")
    }
    
    @objc func featuredViewWasTapped() {
        let newViewController = MovieDetailViewController()
        newViewController.movie = featuredView.movie
        newViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}

