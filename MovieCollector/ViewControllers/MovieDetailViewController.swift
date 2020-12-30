//
//  MovieDetailViewController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/27/20.
//

import UIKit
import Nuke

class MovieDetailViewController: UIViewController {
    
    var movie: Movie!
    var cast: [Cast]?
    var crew: [Crew]?
    
    var titleLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)
        label.numberOfLines = 4
        label.textAlignment = .center
        return label
    }()
    
    var posterImageView : UIImageView = {
        let view = UIImageView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var yearLabel:UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    var runtimeLabel:UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    var ratingLabel:UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    var directorLabel:UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    var overviewLabel:UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        label.numberOfLines = 6
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        APIConnect().getMovieDetailsFor(id: movie.id!) { movie in
            self.movie = movie
            DispatchQueue.main.async {
                self.updateNewMovieDetails()
            }
        }
        
        APIConnect().getMovieCreditsFor(id: movie.id!) { [weak self]results in
            self?.crew = results.crew
            self?.cast = results.cast
            self?.updateCastDetails()
        }
        
        self.navigationItem.title = movie.title
        view.backgroundColor = .systemBackground
        
        self.view.addSubview(titleLabel)
        titleLabel.text = movie.title
        
        self.view.addSubview(yearLabel)
        if let dateString = movie.releaseDate {
            let year = String(dateString.prefix(4))
            yearLabel.attributedText = self.generateBoldRegularAttributedString(boldString: "Released", regularString: year)
        }
        
        self.view.addSubview(runtimeLabel)
        self.view.addSubview(directorLabel)
        self.view.addSubview(ratingLabel)
        
        let overviewLabelTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(overviewLabelTapped))
        overviewLabelTapGesture.numberOfTapsRequired = 1
        overviewLabel.addGestureRecognizer(overviewLabelTapGesture)
        
        self.view.addSubview(overviewLabel)
        if let overviewString = movie.overview {
            overviewLabel.attributedText = generateBoldRegularAttributedString(boldString: "Overview", regularString: overviewString)
        }
        
        self.view.addSubview(posterImageView)
        loadPoster()
        
        layoutConstraints()
    }
    
    func minutesToHoursMinutes (minutes : Double) -> (Double, Double) {
        let hours = floor(minutes / 60)
        let minutes = floor(minutes.truncatingRemainder(dividingBy: 60))
        return (hours, minutes)
    }
    
    func loadPoster () {
        if let poster = movie.posterPath {
            let urlString = APIIMAGEBASEURL + "w500" + poster
            let urlComponents = URLComponents(string: urlString)
            if let url = urlComponents!.url {
                let imageRequest = ImageRequest.init(url: url)
                
                let options = ImageLoadingOptions(
                    placeholder: UIImage(named: "placeholder poster"),
                    transition: .fadeIn(duration: 0.3)
                )
                
                Nuke.loadImage(with: imageRequest,options: options, into: self.posterImageView)
            }
        } else {
            self.posterImageView.image = UIImage(named: "placeholder poster")
        }
    }
    
    func updateNewMovieDetails() {
        if let runtimeDouble = movie.runtime {
            let (h,m) = minutesToHoursMinutes(minutes: runtimeDouble)
            let timeString = String(format:"%.0fh %.0fm", h, m)
            runtimeLabel.attributedText = generateBoldRegularAttributedString(boldString: "Runtime", regularString: timeString)
        }
        if let ratingDouble = movie.voteAverage {
            let ratingString = String(ratingDouble) + "/10"
            ratingLabel.attributedText = generateBoldRegularAttributedString(boldString: "Rating", regularString: ratingString)
        }
    }
    
    func updateCastDetails () {
        DispatchQueue.main.async {
            for crewMember in self.crew! {
                if crewMember.job == "Director" {
                    self.directorLabel.attributedText = self.generateBoldRegularAttributedString(boldString: "Director", regularString: crewMember.name!)
                }
            }
        }
    }
    
    func generateBoldRegularAttributedString (boldString: String, regularString: String) -> NSAttributedString {
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 12)]

        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Regular", size: 14)]

        let attributedString1 = NSMutableAttributedString(string:boldString + "\n", attributes:attrs1 as [NSAttributedString.Key : Any])

        let attributedString2 = NSMutableAttributedString(string:regularString, attributes:attrs2 as [NSAttributedString.Key : Any])

       attributedString1.append(attributedString2)
        
        return attributedString1
        
    }
    
    @objc func overviewLabelTapped() {
        let newViewController = MoreDetailTextViewController()
        newViewController.detailText = movie.overview!
        newViewController.navigationTitle = "Overview"
        newViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func layoutConstraints () {
        
        let layoutConstraint2 = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 2/3, constant: 0)
        layoutConstraint2.isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2)
        ])
        
        let layoutConstraint1 = NSLayoutConstraint(item: posterImageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 0.2, constant: 10)
        layoutConstraint1.isActive = true
        
        NSLayoutConstraint.activate([
            posterImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
//            posterImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            posterImageView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            posterImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3)
        ])
        
//        let layoutConstraint3 = NSLayoutConstraint(item: yearLabel, attribute: .centerX, relatedBy: .greaterThanOrEqual, toItem: titleLabel, attribute: .centerX, multiplier: 1/2, constant: 0)
//        layoutConstraint3.isActive = true
        
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            yearLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4),
            yearLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor)
        ])
        
        NSLayoutConstraint.activate([
            runtimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            runtimeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4),
            runtimeLabel.leftAnchor.constraint(equalTo: yearLabel.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 15),
            ratingLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/5),
            ratingLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            directorLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 15),
            directorLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),
            directorLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(greaterThanOrEqualTo: directorLabel.bottomAnchor, constant: 15),
            overviewLabel.topAnchor.constraint(greaterThanOrEqualTo: posterImageView.bottomAnchor, constant: 15),
            overviewLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            overviewLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
}
