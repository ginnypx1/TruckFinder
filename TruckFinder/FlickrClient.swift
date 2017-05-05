//
//  FlickrClient.swift
//  TruckFinder
//
//  Created by Ginny Pennekamp on 5/5/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit

class FlickrClient : NSObject {
    
    // MARK: - Properties
    
    var session = URLSession.shared
    var flickrRequest = FlickrRequest()
    
    var pageRequested: Int = 0
    
    // MARK: - Decide Which Trucks to Search For
    
    var truckTags: [String] = ["truck", "construction+truck", "emergency+truck", "farm+truck", "garbage+truck", "big+rig", "road+truck", "roadword+truck"]
    
    func getRandomTruckTag(from truckArray: [String]) -> String {
        let randomNumber = Int(arc4random_uniform(UInt32(truckArray.count)))
        return truckArray[randomNumber]
    }
    
    // MARK: - Fetch all Images with SearchText
    
    func fetchImagesWithSearchText(completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        pageRequested += 1
        let searchTags = getRandomTruckTag(from: truckTags)
        
        print("2. Building request for all photos... Page: \(pageRequested), SearchTags: \(searchTags)")
        
        /* Set the Parameters */
        var methodParameters: [String: Any] = [
            FlickrRequest.FlickrParameterKeys.SearchTag: searchTags,
            FlickrRequest.FlickrParameterKeys.ResultsPage: pageRequested]
        
        /* Build the URL */
        var getRequestURL = flickrRequest.buildURL(fromParameters: methodParameters)
        
        /* Configure the request */
        let request = URLRequest(url: getRequestURL)
        
        // create network request
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(nil, NSError(domain: "getImagesWithSearchText", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* Parse the Parse data and use the data (happens in completion handler) */
            self.parseJSONDataWithCompletionHandler(data, completionHandlerForData: completionHandler)
        }
        task.resume()
    }
    
    // MARK: - Fetch single image from URL
    
    func fetchImage(for flickrPhoto: FlickrPhoto, completionHandler: @escaping (_ data: Data?) -> Void) {
        
        /* Build the URL */
        let photoURLString = flickrPhoto.urlString
        let photoURL = URL(string: photoURLString!)
        
        /* Configure the request */
        let request = URLRequest(url: photoURL!)
        
        // create network request
        let task = session.dataTask(with: request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            OperationQueue.main.addOperation {
                flickrPhoto.imageData = data as NSData
                completionHandler(data)
            }
        }
        task.resume()
    }
    
}
