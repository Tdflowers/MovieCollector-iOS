//
//  PosterIconView.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/22/20.
//

import UIKit
import Nuke

class PosterIconView : UICollectionViewCell {
    
    var movie:Movie!
    var posterImageView:UIImageView!
    var titleLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
      //preferred content size, calculate it if some internal state changes
      return CGSize(width: 200, height: 350)
    }
    
    private func setupView() {
        self.backgroundColor = .white
        
        posterImageView = UIImageView.init(frame: CGRect.init())
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFit
        addSubview(posterImageView)
        
        titleLabel = UILabel.init()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = .myControlWhiteBlackBackground
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.init(name: "AvenirNext-Regular", size: 12)
        addSubview(titleLabel)
        
        setupLayout()
       
    }
    
    func updateMovieDetailsWith(movie:Movie) {
        
        DispatchQueue.main.async {
            self.titleLabel.text = movie.title
            
            
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
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            posterImageView.topAnchor.constraint(equalTo: self.topAnchor),
            posterImageView.heightAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 3/2)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }
}