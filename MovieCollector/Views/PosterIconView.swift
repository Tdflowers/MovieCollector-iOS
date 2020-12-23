//
//  PosterIconView.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/22/20.
//

import UIKit
import Nuke

class PosterIconView : UIView {
    
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
    
    private func setupView() {
        self.backgroundColor = .black
        
        posterImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        addSubview(posterImageView)
        
        titleLabel = UILabel.init(frame: CGRect(x: 0, y: posterImageView.frame.height, width: self.frame.size.width, height: self.frame.size.height - posterImageView.frame.size.height))
        addSubview(titleLabel)
       
    }
    
    func updateMovieDetailsWith(movie:Movie) {
        
        DispatchQueue.main.async {
            self.titleLabel.text = movie.title
            
            if let poster = movie.posterPath {
                let urlString = APIIMAGEBASEURL + "w500" + poster
                let urlComponents = URLComponents(string: urlString)
                if let url = urlComponents!.url {
                    let imageRequest = ImageRequest.init(url: url)
                    print(url)
                    Nuke.loadImage(with: imageRequest, into: self.posterImageView)
                }
            }
        }
    }
}
