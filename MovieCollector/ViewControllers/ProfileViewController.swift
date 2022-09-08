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
    
    var messageRef:DocumentReference?
    var listListener:ListenerRegistration?
    var userId:String?
    
    var watchedMoviesData:[Movie] = [] {
        didSet {
            //Did get now playing movies
            updatedWatchedMoviesView()
        }
    }
    
    var signUpButton:UIButton = {
        let button = UIButton.init(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.backgroundColor = .systemBlue
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
    
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        
        if Auth.auth().currentUser != nil {
            view.addSubview(watchedMoviesCollectionView)
            view.addSubview(signOutButton)
            userId = Auth.auth().currentUser?.uid
            messageRef = Firestore.firestore().collection("lists").document(userId!).collection("movielists").document("watched")
            updatedWatchedMoviesData()
        } else {
            view.addSubview(signUpButton)
        }
        layoutConstraints()
        
        handle = Auth.auth().addStateDidChangeListener { auth, user in
          
        }
        
        signUpButton.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(signOutPressed), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            signUpButton.isHidden = true
//            updatedWatchedMoviesData()
            watchedMoviesCollectionView.posterDelegate = self
        } else {
            view.addSubview(signUpButton)
        }
        
    }
    
    func layoutConstraints () {
        if signUpButton.isDescendant(of: view) {
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
                watchedMoviesCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                watchedMoviesCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            NSLayoutConstraint.activate([
                signOutButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/12),
                signOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                signOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3)
            ])
        }
    }
    
    @objc func signUpPressed () {
        //Popup signup / signin flow
//        let hostingController = UIHostingController(rootView: LoginFlow())
//           hostingController.rootView.dismiss = {
//               hostingController.dismiss(animated: true, completion: nil)
//           }
//           present(hostingController, animated: true, completion: nil)
        
        let loginVC = LoginViewController()
        self.modalPresentationStyle = .overCurrentContext
        self.present(loginVC, animated: true)

    }
    
    @objc func signOutPressed () {
        try! Auth.auth().signOut()
    }
    
    func updatedWatchedMoviesView() {
        watchedMoviesCollectionView.moviesData = watchedMoviesData
    }
    
    func beginListeningForChangeInList () {
        
    }
    
    func updatedWatchedMoviesData() {
        
    var tempArray:[Movie] = []
    
        listListener = messageRef!.addSnapshotListener { doc, error in
        if let doc = doc {
            if doc.exists {
                if let data = doc.data() {
                    tempArray = []
                    for (_, value) in data {
                        if let movie = value as? Dictionary<String, Any> {
                            tempArray.append(Movie.init(id: movie["movieDbId"] as? Int64, title: movie["title"] as? String, overview: nil, posterPath: movie["posterUrl"] as? String, releaseDate: movie["releaseYear"] as? String, adult: nil, genreIds: nil, popularity: nil, voteCount: nil, video: nil, voteAverage: nil, backdropPath: nil, originalTitle: nil, originalLanguage: nil, runtime: nil))
                        }
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"

                    let sortedArray = tempArray.sorted { dateFormatter.date(from: $0.releaseDate!)! < dateFormatter.date(from: $1.releaseDate!)! }
                    self.watchedMoviesData = sortedArray.reversed()
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
