//
//  FlickrConvenience.swift
//  TruckFinder
//
//  Created by Ginny Pennekamp on 5/5/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit

extension FlickrClient {
    
    // MARK: - Parse JSON Data
    
    func parseJSONDataWithCompletionHandler(_ data: Data, completionHandlerForData: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        print("3. Parsing JSON...")
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForData(nil, NSError(domain: "parseJSONDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        OperationQueue.main.addOperation {
            completionHandlerForData(parsedResult, nil)
        }
    }
    
    // MARK: - Extract All Photos from JSON
    
    func extractAllPhotoURLStrings(fromJSONDictionary jsonDictionary: AnyObject) -> [String] {
        print("4. Extracting list of all photos from JSON")
        
        var allPhotoStrings = [String]()
        
        guard let OKResponse = jsonDictionary[FlickrRequest.FlickrResponseKeys.Status] as? String, let photos = jsonDictionary[FlickrRequest.FlickrResponseKeys.Photos] as? [String: Any], let photosArray = photos[FlickrRequest.FlickrResponseKeys.Photo] as? [[String:Any]] else {
            print("The proper keys are not in the provided JSON Array.")
            return []
        }
        
        if OKResponse == FlickrRequest.FlickrResponseValues.OKStatus {
            for photoDict in photosArray {
                if let photoURLString = photoDict["url_m"] as? String {
                    allPhotoStrings.append(photoURLString)
                }
            }
        } else {
            print("The request to Flickr was not successful.")
        }
        return allPhotoStrings
    }
    
}
