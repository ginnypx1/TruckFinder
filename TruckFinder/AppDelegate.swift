//
//  AppDelegate.swift
//  TruckFinder
//
//  Created by Ginny Pennekamp on 5/5/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let stack = CoreDataStack(modelName: "Model")!
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // autosave every minute
        stack.autoSave(30)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Save when the application is about to move from active to inactive state.
        do {
            try stack.saveContext()
        } catch {
            print("There was an error saving the app data in WillResignActive.")
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Save when application enters the background
        do {
            try stack.saveContext()
        } catch {
            print("There was an error saving the app data in DidEnterBackground.")
        }
    }
    
    
}

