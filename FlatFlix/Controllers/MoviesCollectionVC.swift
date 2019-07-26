//
//  MoviesCollectionVC.swift
//  FlatFlix
//
//  Created by Philip Plamenov on 24.07.19.
//  Copyright © 2019 Philip Plamenov. All rights reserved.
//

import UIKit
import CoreData
class MoviesCollectionVC: UIViewController, CollectionRowSelectionDelegate {
    
    @IBOutlet weak var filter: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector:#selector(self.refreshTableView), name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
    }
    
    
    @IBAction func filterMovies(_ sender: Any) {
        let filterAlert = UIAlertController(title: "Filter", message: "Select filter.", preferredStyle: UIAlertController.Style.alert)
        
        filterAlert.addAction(UIAlertAction(title: "Popular", style: .default, handler: { (action: UIAlertAction!) in
            Helper.downloadMoviesData(sortedBy: Helper.filterPopular)
            Helper.showLoadingPopup(onVC: self)
        }))
        
        filterAlert.addAction(UIAlertAction(title: "Top rated", style: .default, handler: { (action: UIAlertAction!) in
            Helper.downloadMoviesData(sortedBy: Helper.filterTopRated)
            Helper.showLoadingPopup(onVC: self)
        }))
        
        filterAlert.addAction(UIAlertAction(title: "Favourites", style: .default, handler: { (action: UIAlertAction!) in
            self.getFavourites()
        }))
        filterAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(filterAlert, animated: true, completion: nil)
    }
    func getFavourites(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        var movies = [[String:Any]]()
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                var movie = [String:Any]()
                
                movie["id"] = data.value(forKey: "id") as? Int
                movie["title"] = data.value(forKey: "name") as? String
                movie["original_title"] = data.value(forKey: "originalName") as? String
                movie["overview"] = data.value(forKey: "overview") as? String
                movie["release_date"] = data.value(forKey: "releaseDate") as? String
                movie["vote_average"] = data.value(forKey: "rating") as? Double
                movie["popularity"] = data.value(forKey: "popularity") as? Double
                movie["adult"] = data.value(forKey: "adult") as? Bool
                movie["poster_path"] = data.value(forKey: "poster") as? String
                movies.append(movie)
            }
            Helper.moviesDict.removeAll()
            Helper.createMovies(fromArray: movies, page: 1)
            
            self.tableView.reloadData()
            
        } catch {
            
            print("Failed")
        }
    }
    
    func didSelect(movie: MovieModel?, page: Int) {
        performSegue(withIdentifier: "showMovieDetails", sender: movie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailVC {
            destination.movie = sender as? MovieModel
        }
    }
    
    @objc func refreshTableView () {
        DispatchQueue.main.async{
            
            self.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)
        }
    }
}

extension MoviesCollectionVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Helper.moviesDict.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let moviesArr = Helper.moviesDict[section] else { return 0 }
        if moviesArr.isEmpty { return 0 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoviesTableViewCell
        cell.collectionView.reloadData() // clear old images when reusing collectionView cell
        cell.collectionView.setContentOffset(CGPoint.zero, animated: false)
        cell.collectionView.tag = indexPath.section
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
