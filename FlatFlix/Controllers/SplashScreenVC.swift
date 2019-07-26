//
//  ViewController.swift
//  FlatFlix
//
//  Created by Philip Plamenov on 23.07.19.
//  Copyright © 2019 Philip Plamenov. All rights reserved.
//

import UIKit

class SplashScreenVC: UIViewController {

    let myGroup = DispatchGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector:#selector(self.showMoviesVC), name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
        Helper.downloadMoviesData(sortedBy: 1)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
    }
    
    @objc func showMoviesVC(){
        performSegue(withIdentifier: "showMovies", sender: nil)
    }
    
    


}

