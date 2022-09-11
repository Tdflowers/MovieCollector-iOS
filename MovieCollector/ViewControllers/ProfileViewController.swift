//
//  ProfileViewController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/22/20.
//

import UIKit
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController, PosterIconCollectionViewDelegate {
    
    var watchedMovieRef:DocumentReference?
    var towatchMovieRef:DocumentReference?
    var listListener:ListenerRegistration?
    var userId:String?
    
    var watchedMoviesData:[Movie] = [] {
        didSet {
            //Did get now playing movies
            updatedWatchedMoviesView()
        }
    }
    
    var towatchMoviesData:[Movie] = [] {
        didSet {
            updatedtowatchMoviesView()
        }
    }
    
    var signUpButton:UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.filled()
        config.title = "Sign Up"
        config.background.backgroundColor = .systemBackground
        config.background.strokeColor = .label
        config.background.strokeWidth = 1
        config.baseForegroundColor = .label
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            // 1
            var outgoing = incoming
            // 2
            outgoing.font = UIFont.systemFont(ofSize: 22, weight: .medium)
            // 3
            return outgoing
          }
        button.configuration = config
        return button
    }()
    
    var signOutButton:UIButton = {
        let button = UIButton.init(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.backgroundColor = .systemRed
        return button
    }()
    
    var watchedMoviesCollectionView:PosterIconCollectionView = {
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
    var towatchMoviesCollectionView:PosterIconCollectionView = {
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

    
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        
        if Auth.auth().currentUser != nil {
            view.addSubview(watchedMoviesCollectionView)
            view.addSubview(towatchMoviesCollectionView)
            view.addSubview(signOutButton)
            userId = Auth.auth().currentUser?.uid
            watchedMovieRef = Firestore.firestore().collection("lists").document(userId!).collection("movielists").document("watched")
            towatchMovieRef = Firestore.firestore().collection("lists").document(userId!).collection("movielists").document("towatch")
            updateMoviesData(ref: self.watchedMovieRef!, completion: { array in
                self.watchedMoviesData = array
            })
            updateMoviesData(ref: self.towatchMovieRef!, completion: { array in
                self.towatchMoviesData = array
            })
        } else {
            view.addSubview(signUpButton)
        }
        layoutConstraints()
        
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            self.refreshProfile()
        }
        
        signUpButton.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(signOutPressed), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
//            signUpButton.isHidden = true
//            updatedWatchedMoviesData()
            watchedMoviesCollectionView.posterDelegate = self
            towatchMoviesCollectionView.posterDelegate = self
        } else {
            signUpPressed()
        }
        
    }
    
    func layoutConstraints () {
        
        if signUpButton.isDescendant(of: self.view) {
            NSLayoutConstraint.activate([
                signUpButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/8),
                signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3)
            ])
        } else {
            NSLayoutConstraint.activate([
                watchedMoviesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.30),
                watchedMoviesCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
                watchedMoviesCollectionView.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 20),
                watchedMoviesCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            NSLayoutConstraint.activate([
                towatchMoviesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.30),
                towatchMoviesCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
                towatchMoviesCollectionView.topAnchor.constraint(equalTo: watchedMoviesCollectionView.bottomAnchor, constant: 10),
                towatchMoviesCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            NSLayoutConstraint.activate([
                signOutButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/12),
                signOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                signOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3)
            ])
        }
    }
    
    func refreshProfile() {
        if Auth.auth().currentUser != nil {
            self.view.addSubview(self.watchedMoviesCollectionView)
            self.view.addSubview(self.towatchMoviesCollectionView)
            self.view.addSubview(self.signOutButton)
            self.userId = Auth.auth().currentUser?.uid
            self.towatchMovieRef = Firestore.firestore().collection("lists").document(self.userId!).collection("movielists").document("towatch")
            self.watchedMovieRef = Firestore.firestore().collection("lists").document(self.userId!).collection("movielists").document("watched")
            updateMoviesData(ref: self.watchedMovieRef!, completion: { array in
                self.watchedMoviesData = array
            })
            updateMoviesData(ref: self.towatchMovieRef!, completion: { array in
                self.towatchMoviesData = array
            })
            self.signUpButton.removeFromSuperview()
        } else {
            self.userId = nil
            self.watchedMovieRef = nil
            self.towatchMovieRef = nil
            self.view.addSubview(self.signUpButton)
            self.watchedMoviesCollectionView.removeFromSuperview()
            self.towatchMoviesCollectionView.removeFromSuperview()
            self.signOutButton.removeFromSuperview()
            self.signUpButton.isHidden = false
        }
        
        self.layoutConstraints()
    }
    
    @objc func signUpPressed () {
        //Popup signup / signin flow
//        let hostingController = UIHostingController(rootView: LoginFlow())
//           hostingController.rootView.dismiss = {
//               hostingController.dismiss(animated: true, completion: nil)
//           }
//           present(hostingController, animated: true, completion: nil)
        
        let loginVC = SignUpFlowNavController()
        self.modalPresentationStyle = .overCurrentContext
        self.present(loginVC, animated: true)

    }
    
    @objc func signOutPressed () {
        try! Auth.auth().signOut()
    }
    
    func updatedWatchedMoviesView() {
        watchedMoviesCollectionView.moviesData = watchedMoviesData
    }
    
    func updatedtowatchMoviesView() {
        towatchMoviesCollectionView.moviesData = towatchMoviesData
    }
    
    func beginListeningForChangeInList () {
        
    }
    
    func updateMoviesData(ref:DocumentReference, completion: @escaping ([Movie]) -> Void) {
        
        var tempArray:[Movie] = []
    
        listListener = ref.addSnapshotListener { doc, error in
        if let doc = doc {
            if doc.exists {
                if let data = doc.data() {
                    tempArray = []
                    for (_, value) in data {
                        if let movie = value as? Dictionary<String, Any> {
                            tempArray.append(Movie.init(id: movie["movieDbId"] as? Int64, title: movie["title"] as? String, overview: nil, posterPath: movie["posterUrl"] as? String, releaseDate: movie["releaseYear"] as? String ?? "", adult: nil, genreIds: nil, popularity: nil, voteCount: nil, video: nil, voteAverage: nil, backdropPath: nil, originalTitle: nil, originalLanguage: nil, runtime: nil))
                        }
                    }
                    
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let sortedArray = tempArray.sorted { dateFormatter.date(from: $0.releaseDate!) ?? Date.now < dateFormatter.date(from: $1.releaseDate!) ?? Date.now }
//                        self.watchedMoviesData = sortedArray.reversed()
                    completion(sortedArray.reversed())
                    }
                }
            }
        }
    }
    
    
    
    func posterWasTappedWithMovie(_ movie: Movie) {
        let newViewController = MovieDetailViewController()
        newViewController.movie = movie
        newViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func posterWasTappedWithTVSeries(_ series: TVSeries) {
        print("tv series tapped")
    }
    
    deinit {
        listListener?.remove()
    }
}
