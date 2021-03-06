//
//  PhotoViewController.swift
//  TruckFinder
//
//  Created by Ginny Pennekamp on 5/5/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class PhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noImagesLabel: UILabel!
    
    // MARK: - Properties
    var isSmall: Bool = true
    
    var pageRequested: Int = 1
    var isFetching: Bool = false
    var imagesRetrieved: Int = 0
    var hasMoreData: Bool = true
        
    // API call
    var flickrClient = FlickrClient()
    
    // fetched results controller
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var fetchedResultsController: NSFetchedResultsController<FlickrPhoto> = { () -> NSFetchedResultsController<FlickrPhoto> in
        let fetchRequest = NSFetchRequest<FlickrPhoto>(entityName: "FlickrPhoto")
        fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.delegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    var selectedIndexes = [IndexPath]()
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths: [IndexPath]!
    var updatedIndexPaths: [IndexPath]!
    
    // activity indicator
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add activity indicator
        addActivityIndicator()
        // set up custom flow
        fitCollectionFlowToSize(self.view.frame.size, numberHorizontal: 5.0, numberVertical: 3.0)
        // hide noImagesLabel
        noImagesLabel.isHidden = true
        
        // start the fetched results controller
        do {
            try fetchedResultsController.performFetch()
            // if empty, download images
            if self.fetchedResultsController.fetchedObjects?.count == 0 {
                fetchImages()
            }
        } catch {
            print("Error performing initial fetch")
        }
    }
    
    // MARK: - Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        print("number Of Cells: \(sectionInfo.numberOfObjects)")
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSmall {
            fitCollectionFlowToSize(self.view.frame.size, numberHorizontal: 3.0, numberVertical: 2.0)
            self.isSmall = false
        } else {
            fitCollectionFlowToSize(self.view.frame.size, numberHorizontal: 5.0, numberVertical: 3.0)
            self.isSmall = true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewCell", for: indexPath) as! PhotoViewCell
        
        if self.fetchedResultsController.fetchedObjects?.count != 0 {
            let flickrPhoto = self.fetchedResultsController.object(at: indexPath) as FlickrPhoto
            let urlString = flickrPhoto.urlString!
            // if image is cached
            if let cachedImage = delegate.imageCache.object(forKey: urlString as AnyObject) as? UIImage {
                print("Loading from cache.")
                cell.update(with: cachedImage)
            } else {
                // download and store the image
                flickrClient.fetchImage(for: flickrPhoto) { (data: Data?) -> Void in
                    print("6. Fetching image data for photo...")
                    // return on main thread
                    guard let imageData = data, let image = UIImage(data: imageData) else {
                        print("Image data could not be extracted")
                        return
                    }
                    
                    let photoIndexPath = IndexPath(item: indexPath.row, section: 0)
                    if let cell = self.collectionView.cellForItem(at: photoIndexPath)
                        as? PhotoViewCell {
                        print("7. displaying photo")
                        cell.update(with: image)
                    }
                }
            }
            
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // if not fetching run this code
        if !isFetching {
            if indexPath.row >= (self.imagesRetrieved - 3) {
                print("Requesting more images...")
                self.pageRequested += 1
                fetchImages()
            }
        }
    }
    
    
    // MARK: - Fetched Results Controller Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths = [IndexPath]()
        deletedIndexPaths = [IndexPath]()
        updatedIndexPaths = [IndexPath]()
        
        print("in controllerWillChangeContent")
    }
    
    // The method may be called multiple times, once for each object added, deleted, or changed.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
        case .insert:
            print("Insert an item")
            insertedIndexPaths.append(newIndexPath!)
            break
        case .delete:
            print("Delete an item")
            deletedIndexPaths.append(indexPath!)
            break
        case .update:
            print("Update an item.")
            updatedIndexPaths.append(indexPath!)
            break
        case .move:
            print("Move an item. We don't expect to see this in this app.")
            break
            //default:
            //break
        }
    }
    
    // This method is invoked after all of the changed objects in the current batch have been collected
    // into the three index path arrays (insert, delete, and upate). We now need to loop through the
    // arrays and perform the changes.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("in controllerDidChangeContent. changes.count: \(insertedIndexPaths.count + deletedIndexPaths.count)")
        
        collectionView.performBatchUpdates({() -> Void in
            for indexPath in self.insertedIndexPaths {
                self.collectionView.insertItems(at: [indexPath])
            }
            for indexPath in self.deletedIndexPaths {
                self.collectionView.deleteItems(at: [indexPath])
            }
            for indexPath in self.updatedIndexPaths {
                self.collectionView.reloadItems(at: [indexPath])
            }
        }, completion: nil)
    }
    
    // MARK: - Fetch Images from Flickr
    
    func fetchImages() {
        
        guard isFetching == false else { return }
        guard hasMoreData == true else { return }
        
        activityIndicator.startAnimating()
        noImagesLabel.isHidden = true
        
        isFetching = true
        
        print("1. Starting request for photos...")
        
        flickrClient.fetchImagesWithSearchText(pageRequested: self.pageRequested) { (data: AnyObject?, error: NSError?) -> Void in
            // returned from JSON parsing on main thread
            
            self.isFetching = false
            self.activityIndicator.stopAnimating()
            
            if error != nil {
                print("There was an error getting the images: \(String(describing: error))")
                
                if isInternetAvailable() == false {
                    Alerts.displayInternetConnectionAlert(from: self)
                } else {
                    Alerts.displayStandardAlert(from: self)
                }
            } else {
                guard let data = data else {
                    print("No data was returned.")
                    return
                }
                let photoURLs = self.flickrClient.extractAllPhotoURLStrings(fromJSONDictionary: data)
                
                if !photoURLs.isEmpty {
                    print("5. There were \(photoURLs.count) photos returned.")
                    
                    if photoURLs.count < 21 {
                        self.hasMoreData = false
                    }
                    
                    self.imagesRetrieved += photoURLs.count

                    for url in photoURLs {
                        self.delegate.stack.addFlickrPhotoToDatabase(urlString: url, fetchedResultsController: self.fetchedResultsController)
                    }
                } else {
                    self.noImagesLabel.isHidden = false
                }
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    // MARK: - Remove Selected Photos
    
    func deleteAllFlickrPhotos() {
        for photo in self.fetchedResultsController.fetchedObjects! {
            delegate.stack.context.delete(photo)
        }
    }
    
    @IBAction func deleteAllPhotos(_ sender: Any) {
        deleteAllFlickrPhotos()
    }
    
}


