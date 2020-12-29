//
//  FeaturedMovieView.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/23/20.
//

import UIKit

class FeaturedMovieView: UIView {
    
    var posterImage:PosterIconView!
    var titleLabel: UILabel!
    var overViewLabel: UILabel!
    var movie:Movie! {
        didSet {
            self.posterImage.movie = movie
            DispatchQueue.main.async {
                self.titleLabel.text = self.movie.title
                self.overViewLabel.text = self.movie.overview
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .systemBackground
        
        posterImage = PosterIconView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        posterImage.shouldShowTitle = false
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        posterImage.backgroundColor = .clear
        self.addSubview(posterImage)
            
        titleLabel = UILabel.init(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.init(name: "AvenirNext-Bold", size: 18)
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        
        overViewLabel = UILabel.init(frame: .zero)
        overViewLabel.translatesAutoresizingMaskIntoConstraints = false
        overViewLabel.font = UIFont.init(name: "AvenirNext-Light", size: 12)
        overViewLabel.numberOfLines = 8
        overViewLabel.textAlignment = .center
        self.addSubview(overViewLabel)
        
        setupLayout()
        
        /*
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        */
       
    }
    
    private func setupLayout() {
        
        let layoutConstraint1 = NSLayoutConstraint(item: posterImage!, attribute: .centerX, relatedBy: .lessThanOrEqual, toItem: self, attribute: .trailing, multiplier: 0.2, constant: 0)
        layoutConstraint1.isActive = true
        
        let layoutConstraint2 = NSLayoutConstraint(item: titleLabel!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 2/3, constant: 0)
        layoutConstraint2.isActive = true
        let layoutConstraint3 = NSLayoutConstraint(item: overViewLabel!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 2/3, constant: 0)
        layoutConstraint3.isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2),
//            titleLabel.topAnchor.constraint(equalTo: posterImage.)
        ])
        
        NSLayoutConstraint.activate([
            overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overViewLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: 1)
            
        ])
        
        
        NSLayoutConstraint.activate([
            posterImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            posterImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            posterImage.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 2/3)
        ])
    }

}
