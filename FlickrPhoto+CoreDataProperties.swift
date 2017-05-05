//
//  FlickrPhoto+CoreDataProperties.swift
//  TruckFinder
//
//  Created by Ginny Pennekamp on 5/5/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import CoreData


extension FlickrPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlickrPhoto> {
        return NSFetchRequest<FlickrPhoto>(entityName: "FlickrPhoto")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var urlString: String?

}
