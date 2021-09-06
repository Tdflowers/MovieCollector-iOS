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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .systemBackground
        
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barStyle = .default
        searchBar.placeholder = "Movie Search"
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        view.addSubview(searchBar)
        view.addSubview(searchResultsCollectionView)
        
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
            searchResultsCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
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
        let requestWorkItem = DispatchWorkItem { [weak self] in
            let apic = APIConnect.shared()
            apic.getSearchResults(languge: "en-US", region: "US", query: searchText, page: "1") { results in
//                self?.updateSearchResults(results: results)
                self?.searchResultsCollectionView.moviesData = results.movies
                self?.searchResultsCollectionView.searchQuery = searchText
                self?.searchResultsCollectionView.currentPageNumber = 1
                self?.searchResultsCollectionView.pageMax = results.totalPages
            }
        }
        // Save the new work item and execute it after 250 ms
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500),
                                      execute: requestWorkItem)
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
}
