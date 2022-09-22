//
//  SearchViewController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/22/20.
//

import UIKit

class SearchViewController: UIViewController , UISearchBarDelegate, PosterIconCollectionViewDelegate{
    
    var searchBar:UISearchBar!
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    var searchResultsCollectionView:PosterIconCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
                
        let view = PosterIconCollectionView.init(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.dataSource = view
        view.delegate = view
        view.isHorizontal = false
        view.keyboardDismissMode = .onDrag
        view.allowsSelection = true
        view.register(PosterIconView.self, forCellWithReuseIdentifier: "cell")
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return view
    }()
    
    var searchOptionSegmentedControl:UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Movies","TV Shows", "Users"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = .systemBlue
        segmentedControl.backgroundColor = .secondarySystemBackground
        return segmentedControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .systemBackground
        
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barStyle = .default
        searchBar.placeholder = "Search"
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        view.addSubview(searchBar)
        view.addSubview(searchResultsCollectionView)
        view.addSubview(searchOptionSegmentedControl)
        
        layoutSubviews()
        
        searchResultsCollectionView.posterDelegate = self
        
        searchBar.becomeFirstResponder()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
               tap.cancelsTouchesInView = false
               searchResultsCollectionView.addGestureRecognizer(tap)

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        if searchBar.text == "" {
            searchBar.becomeFirstResponder()
        }
    }
    
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    var scrollView:UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    func layoutSubviews() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchOptionSegmentedControl.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchOptionSegmentedControl.widthAnchor.constraint(equalTo: searchBar.widthAnchor)
        ])
    
        NSLayoutConstraint.activate([
            searchResultsCollectionView.topAnchor.constraint(equalTo: searchOptionSegmentedControl.bottomAnchor),
            searchResultsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchResultsCollectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        if searchText == "" {
            self.searchResultsCollectionView.moviesData = []
            return
        }
        // Cancel the currently pending item
        pendingRequestWorkItem?.cancel()

        // Wrap our request in a work item
//        let requestWorkItem = DispatchWorkItem { [weak self] in
//            let apic = APIConnect.shared()
//            apic.getMovieSearchResults(languge: "en-US", region: "US", query: searchText, page: "1") { results in
////                self?.updateSearchResults(results: results)
//                self?.searchResultsCollectionView.moviesData = results.movies
//                self?.searchResultsCollectionView.searchQuery = searchText
//                self?.searchResultsCollectionView.currentPageNumber = 1
//                self?.searchResultsCollectionView.pageMax = results.totalPages
//            }
//        }
        
        if searchOptionSegmentedControl.selectedSegmentIndex == 0 {
            
            let requestWorkItem = DispatchWorkItem { [weak self] in
                let apic = APIConnect.shared()
                apic.getMovieSearchResults(languge: "en-US", region: "en-US", query: searchText, page: "1") { results in
    //                self?.updateSearchResults(results: results)
                    self?.searchResultsCollectionView.isMoviesData = true
                    self?.searchResultsCollectionView.moviesData = results.movies
                    self?.searchResultsCollectionView.searchQuery = searchText
                    self?.searchResultsCollectionView.currentPageNumber = 1
                    self?.searchResultsCollectionView.pageMax = results.totalPages
                }
            }
            pendingRequestWorkItem = requestWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500),
                                          execute: requestWorkItem)
        } else if searchOptionSegmentedControl.selectedSegmentIndex == 1 {
            let requestWorkItem = DispatchWorkItem { [weak self] in
                let apic = APIConnect.shared()
                apic.getTVSearchResults(languge: "en-US", query: searchText, page: "1") { results in
    //                self?.updateSearchResults(results: results)
                    self?.searchResultsCollectionView.tvSeriesData = results.shows
//                    self?.searchResultsCollectionView.searchQuery = searchText
                    self?.searchResultsCollectionView.isMoviesData = false
                    self?.searchResultsCollectionView.currentPageNumber = 1
                    self?.searchResultsCollectionView.pageMax = results.totalPages
                }
            }
            pendingRequestWorkItem = requestWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500),
                                          execute: requestWorkItem)
        } else if searchOptionSegmentedControl.selectedSegmentIndex == 2 {
            
        }
        
        // Save the new work item and execute it after 250 ms
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(results: MovieSearchResults) {
        
    }
    
    func posterWasTappedWithMovie(_ movie: Movie) {
        
        searchBar.resignFirstResponder()
        
        let newViewController = MovieDetailViewController()
        newViewController.movie = movie
        newViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func posterWasTappedWithTVSeries(_ series: TVSeries) {
        var totalRuntime:Int64 = 0
        let alert = UIAlertController(title: nil, message: "Calculating Length...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        APIConnect.shared().getTVSeriesDetailsFor(show: series.id!, completion: { results in
            for seasonNumber in (1...Int64(results.numberOfSeasons!)) {
                APIConnect.shared().getTVSeriesSeasonDetailsFor(show: series.id!, season: seasonNumber) { seriesResults in
                    for episode in seriesResults.episodes! {
                        if let runtime = episode.runtime {
                            totalRuntime += runtime
                        }
                    }
                }
            }
            DispatchQueue.main.async() {
                if let vc = self.presentedViewController, vc is UIAlertController {
                    self.dismiss(animated: false) {
                        if totalRuntime == 0 {
                            
                            let alert = UIAlertController(title: series.name, message: "Sorry, this show doesn't have exact runtimes yet", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { _ in
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            return
                        }
                        
                        let days = String((totalRuntime / 1440)) + " days "
                        let hours = String((totalRuntime % 1440) / 60) + " hours "
                        let minutes = String(totalRuntime % 60) + " minutes"
                        
                        let alert = UIAlertController(title: series.name, message: "Would take " + days + hours + minutes + " to watch", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { _ in
                            //Cancel Action
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        })
    }
    
    internal func dismissAlert() {
        
    }
}
