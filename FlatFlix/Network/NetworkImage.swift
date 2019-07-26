//
//  NetworkImage.swift
//  FlatFlix
//
//  Created by Philip Plamenov on 25.07.19.
//  Copyright © 2019 Philip Plamenov. All rights reserved.
//

import UIKit


// LOADS IMAGES IN COLLECTION VIEW CELL FROM URL
let imageCache = NSCache<NSString, UIImage>()

class NetworkImage: UIImageView {

    var imageUrlString: String?

    func imageFromURL(_ URLString: String, placeHolder: UIImage?) {
        
        imageUrlString = URLString
        
        self.image = nil
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = self.frame
        activityIndicator.center = CGPoint(x: self.frame.size.width  / 2,
                                           y: self.frame.size.height / 2)
        activityIndicator.color = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            activityIndicator.stopAnimating()
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //print("RESPONSE FROM API: \(response)")
                if let errorMsg = error {
                    print("ERROR LOADING IMAGES FROM URL: \(errorMsg)")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                        activityIndicator.stopAnimating()
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            
                            
                            if self.imageUrlString == URLString {
                                self.image = downloadedImage
                            }
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            
                            
                            activityIndicator.stopAnimating()
                            return
                        }
                    }
                }
            }).resume()
            self.image = placeHolder
            activityIndicator.stopAnimating()
        }
    }


}
