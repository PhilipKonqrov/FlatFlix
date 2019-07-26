//
//  MoviesTableViewCell.swift
//  FlatFlix
//
//  Created by Philip Plamenov on 24.07.19.
//  Copyright © 2019 Philip Plamenov. All rights reserved.
//

import UIKit

protocol CollectionRowSelectionDelegate {
    func didSelect(movie: MovieModel?, page: Int)
}

class MoviesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: CollectionRowSelectionDelegate?
    var moviesArr = [MovieModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        moviesArr = Helper.moviesDict[collectionView.tag] ?? []
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (Helper.moviesDict[collectionView.tag] ?? []).count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MoviesCollectionViewCell
        let posterUrl = "https://image.tmdb.org/t/p/w500" + (Helper.moviesDict[collectionView.tag]?[indexPath.item].poster ?? "")
        cell.moviePoster.imageFromURL(posterUrl, placeHolder: #imageLiteral(resourceName: "logo_transparent"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelect(movie: Helper.moviesDict[collectionView.tag]?[indexPath.item], page: collectionView.tag)
    }
    

}
extension MoviesTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 2
        let hardCodedPadding:CGFloat = 10
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
