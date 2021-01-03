//
//  PosterIconCollectionView.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/23/20.
//

import UIKit

protocol PosterIconCollectionViewDelegate {
    func posterWasTappedWithMovie(_ movie:Movie)
}

class PosterIconCollectionView: UICollectionView {
    
    var moviesData:[Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    var isHorizontal = true
    
    var currentPageNumber = 1
    var searchQuery:String?
    var pageMax:Double?
    
    var posterDelegate:PosterIconCollectionViewDelegate?
    
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
        cell.shouldShowTitle = true
        cell.updateMovieDetailsWith(movie: moviesData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isHorizontal {
            var width:CGFloat = 0.0
            
            let height = collectionView.frame.size.height - 20
            
            width = height * 1/2
            return CGSize.init(width: width, height: height)
        } else {
            let width = collectionView.frame.size.width/4
            return CGSize.init(width: width, height: width*2)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == moviesData.count - 1 ) { //it's your last cell
            if let search = searchQuery {
                currentPageNumber = currentPageNumber + 1
                if let pageMaxInt = pageMax {
                    if Int(pageMaxInt) >= currentPageNumber {
                        let pageString = String(currentPageNumber)
                        APIConnect.shared().getSearchResults(languge: "en-US", region: "US", query: search, page: pageString) { results in
                            self.moviesData += results.movies
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        posterDelegate?.posterWasTappedWithMovie(moviesData[indexPath.row])
    }
}
