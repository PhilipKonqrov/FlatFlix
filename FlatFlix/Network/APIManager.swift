//
//  APIManager.swift
//  FlatFlix
//
//  Created by Philip Plamenov on 23.07.19.
//  Copyright © 2019 Philip Plamenov. All rights reserved.
//

import Foundation
class APIManager {
    
   
    static let apiKey = Constants.apiKey
    static let sharedInstance = APIManager()
    let baseURL = "https://api.themoviedb.org/3"
    let getEndpoint = "/discover/movie"
    
    let headers = [
        "x-requested-with": "XMLHttpRequest",
        "cache-control": "no-cache",
    ]
    
    func discoverMovies(sortBy: Int?, page: Int?, onSuccess: @escaping([[String:Any]], Int) -> Void, onFailure: @escaping(Error) -> Void){
        let page = page ?? 1
        var filter = ""
        if let sortId = sortBy { filter = "&sort_by=\(setFilter(withNumber: sortId))" }
        
        let url = baseURL + getEndpoint + "?api_key=\(APIManager.apiKey)" + filter + "&page=\(page)"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if(error != nil){
                onFailure(error!)
            } else {
                guard let responseData = data else { return }
                do {
                    if let parsedResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                        guard let movies = parsedResponse["results"] as? [[String:Any]] else { return }
                        onSuccess(movies, page)
                    }
                } catch let jsonErr {
                    print("Error serializing json: ", jsonErr)
                }
            }
        })
        dataTask.resume()
    }
    
    func setFilter(withNumber: Int) -> String {
        switch withNumber {
        case 0:
            return "vote_average.desc"
        case 1:
            return "popularity.desc"
        default:
            return "popularity.desc"
        }
    }
    
    func getConfig(){
        let url = baseURL + "/configuration" + "?api_key=\(APIManager.apiKey)"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if(error != nil){
                
            } else {
                guard let responseData = data else { return }
                do {
                    if let parsedResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                        guard let imagesConfig = parsedResponse["images"] as? [String:Any] else { return }
                        print(imagesConfig)
                    }
                } catch let jsonErr {
                    print("Error serializing json: ", jsonErr)
                }
            }
        })
        dataTask.resume()
    }
    
    
}
