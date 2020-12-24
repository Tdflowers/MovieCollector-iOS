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
        self.backgroundColor = .white
        
        posterImage = PosterIconView.init(frame: .zero)
        posterImage.shouldShowTitle = false
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(posterImage)
            
        titleLabel = UILabel.init(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.init(name: "AvenirNext-Bold", size: 18)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        
        overViewLabel = UILabel.init(frame: .zero)
        overViewLabel.translatesAutoresizingMaskIntoConstraints = false
        overViewLabel.font = UIFont.init(name: "AvenirNext-Light", size: 12)
        overViewLabel.numberOfLines = 5
        overViewLabel.textAlignment = .center
        self.addSubview(overViewLabel)
        
        setupLayout()
       
    }
    
    private func setupLayout() {
        
        let layoutConstraint1 = NSLayoutConstraint(item: posterImage!, attribute: .centerX, relatedBy: .lessThanOrEqual, toItem: self, attribute: .trailing, multiplier: 0.2, constant: 0)
        layoutConstraint1.isActive = true
        
        let layoutConstraint2 = NSLayoutConstraint(item: titleLabel!, attribute: .centerX, relatedBy: .lessThanOrEqual, toItem: self, attribute: .trailing, multiplier: 2/3, constant: 0)
        layoutConstraint2.isActive = true
        let layoutConstraint3 = NSLayoutConstraint(item: overViewLabel!, attribute: .centerX, relatedBy: .lessThanOrEqual, toItem: self, attribute: .trailing, multiplier: 2/3, constant: 0)
        layoutConstraint3.isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2),
            titleLabel.topAnchor.constraint(equalTo: posterImage.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overViewLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: 1)
            
        ])
        
        NSLayoutConstraint.activate([
            posterImage.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 0.8),
            posterImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

}
