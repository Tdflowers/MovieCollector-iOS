//
//  PosterIconCollectionView.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/23/20.
//

import UIKit

class PosterIconCollectionView: UICollectionView {
    
    var moviesData:[Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension PosterIconCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PosterIconView
        cell.backgroundColor = .clear
        cell.updateMovieDetailsWith(movie: moviesData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width:CGFloat = 0.0
        
        if collectionView.frame.size.width * 0.25 <= 100 {
            width = 100
        } else {
            width = collectionView.frame.size.width * 0.25
        }
        return CGSize.init(width: width, height: collectionView.frame.size.height - 20)
    }
    
    
}
