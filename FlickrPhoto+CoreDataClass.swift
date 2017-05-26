//
//  FlickrPhoto+CoreDataClass.swift
//  TruckFinder
//
//  Created by Ginny Pennekamp on 5/5/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import CoreData


public class FlickrPhoto: NSManagedObject {
    
    convenience init(urlString: String, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "FlickrPhoto", in: context) {
            self.init(entity: ent, insertInto: context)
            self.urlString = urlString
        } else {
            fatalError("Unable to find FlickrPhoto Entity!")
        }
    }
}
