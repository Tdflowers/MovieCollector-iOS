//
//  PosterIconCollectionView.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/23/20.
//

import UIKit

protocol PosterIconCollectionViewDelegate {
    func posterWasTappedWithMovie(_ movie:Movie)
    func posterWasTappedWithTVSeries(_ series:TVSeries)
}

class PosterIconCollectionView: UICollectionView {
    
    var moviesData:[Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    var tvSeriesData:[TVSeries] = [] {
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
    
    var isMoviesData = true
    
    var posterDelegate:PosterIconCollectionViewDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PosterIconCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isMoviesData {
            return moviesData.count
        } else {
            return tvSeriesData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PosterIconView
        cell.backgroundColor = .clear
        cell.shouldShowTitle = true
        if isMoviesData {
            cell.updateMovieDetailsWith(movie: moviesData[indexPath.row])
        } else {
            cell.updateTvSeriesDetailsWith(tvSeries: tvSeriesData[indexPath.row])
        }
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
        
        var resultsCount = 0
        if isMoviesData {
            resultsCount = moviesData.count
        } else {
            resultsCount = tvSeriesData.count
        }
        if (indexPath.row == resultsCount - 1 ) { //it's your last cell
            if let search = searchQuery {
                currentPageNumber = currentPageNumber + 1
                if let pageMaxInt = pageMax {
                    if Int(pageMaxInt) >= currentPageNumber {
                        let pageString = String(currentPageNumber)
                        if isMoviesData {
                            APIConnect.shared().getMovieSearchResults(languge: "en-US", region: "US", query: search, page: pageString) { results in
                                self.moviesData += results.movies
                            }
                        } else {
                            APIConnect.shared().getTVSearchResults(languge: "en-US", query: search, page: pageString) { results in
                                self.tvSeriesData += results.shows
                            }
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMoviesData {
            posterDelegate?.posterWasTappedWithMovie(moviesData[indexPath.row])
        } else {
            posterDelegate?.posterWasTappedWithTVSeries(tvSeriesData[indexPath.row])
        }
    }
}
