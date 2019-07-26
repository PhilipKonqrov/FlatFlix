//
//  MovieDetailVC.swift
//  FlatFlix
//
//  Created by Philip Plamenov on 25.07.19.
//  Copyright © 2019 Philip Plamenov. All rights reserved.
//

import UIKit
import CoreData
class MovieDetailVC: UIViewController {

    var movie: MovieModel?
    
    @IBOutlet weak var movieImage: NetworkImage!
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieOriginalName: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    
    @IBOutlet weak var movieOverview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()

        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.tintColor = UIColor.white
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        let rightButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(rightButtonAction(sender:)))
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
        self.navigationItem.rightBarButtonItem = rightButtonItem
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = self.view.tintColor
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    @objc func rightButtonAction(sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context)
        let newMovie = NSManagedObject(entity: entity!, insertInto: context)
        
        newMovie.setValue(movie?.name, forKey: "name")
        newMovie.setValue(movie?.originalName, forKey: "originalName")
        newMovie.setValue(movie?.overview, forKey: "overview")
        newMovie.setValue(movie?.voteAverage, forKey: "rating")
        newMovie.setValue(movie?.releaseDate, forKey: "releaseDate")
        newMovie.setValue(movie?.poster, forKey: "poster")
        newMovie.setValue(movie?.id, forKey: "id")
        newMovie.setValue(movie?.popularity, forKey: "popularity")
        newMovie.setValue(movie?.adult, forKey: "adult")
        
        
        
        do {
            try context.save()
            print("Saved!")
        } catch {
            print("Failed saving")
        }
    }
    
    func setupView() {
        let imgPath = "https://image.tmdb.org/t/p/original" + (movie?.poster ?? "")
        movieImage.imageFromURL(imgPath, placeHolder: #imageLiteral(resourceName: "logo_transparent"))
        setGradientBackground(view: detailView, colorTop: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2030982449), colorBottom: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
        movieName.text = movie?.name
        movieOriginalName.text = "Original Name: \(movie?.originalName ?? "")"
        movieReleaseDate.text = "Release date: \(movie?.releaseDate ?? "")"
        movieRating.text = "Rating: \(String(movie?.voteAverage ?? 0))"
        movieOverview.text = movie?.overview
    }
    
    func setGradientBackground(view: UIView, colorTop: UIColor, colorBottom: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

}
