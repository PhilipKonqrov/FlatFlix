//
//  Helper.swift
//  FlatFlix
//
//  Created by Philip Plamenov on 24.07.19.
//  Copyright © 2019 Philip Plamenov. All rights reserved.
//

import Foundation
import UIKit
class Helper {
    // Filter constants
    static let filterPopular = 1
    static let filterTopRated = 0
    
    static var moviesDict = [Int:[MovieModel]]()
    static func createMovies(fromArray:[[String:Any]], page:Int) {
        var movies = [MovieModel]()
        for movie in fromArray {
            let id = movie["id"] as? Int
            let name = movie["title"] as? String
            let poster = movie["poster_path"] as? String
            let overview = movie["overview"] as? String
            let releaseDate = movie["release_date"] as? String
            let adult = movie["adult"] as? Bool
            let voteAverage = movie["vote_average"] as? Double
            let popularity = movie["popularity"] as? Double
            let originalName = movie["original_title"] as? String
            let mov = MovieModel(id: id, name: name, originalName: originalName, poster: poster, overview: overview, releaseDate: releaseDate, adult: adult, voteAverage: voteAverage, popularity: popularity)
            movies.append(mov)
        }
        moviesDict[page-1] = movies
    }
    
    static let myGroup = DispatchGroup()
    static func downloadMoviesData(sortedBy: Int?){
        Helper.moviesDict.removeAll()
        let sem = DispatchSemaphore(value: 1)
        
        for page in 1...10 {
            myGroup.enter()
            DispatchQueue.global().async {
                sem.wait()
                
                APIManager.sharedInstance.discoverMovies(sortBy: sortedBy, page: page, onSuccess: { (movies, page) in
                    _ = Helper.createMovies(fromArray: movies, page: page)
                    
                    sem.signal()
                    self.myGroup.leave()
                }) { (err) in
                    print(err)
                    sem.signal()
                    self.myGroup.leave()
                }
                
            }
        }
        
        myGroup.notify(queue: .main) {
            print("Finished loading objects.")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
            }
        }
    }
    
    static func showLoadingPopup(onVC: UIViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(NSAttributedString(string: "Loading movies...", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)]), forKey: "attributedTitle")
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.white
        loadingIndicator.color = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        
        //        UIVisualEffectView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).effect = UIBlurEffect(style: .dark)
        
        onVC.present(alert, animated: true, completion: nil)
    }
    
}
