//
//  PhotoCollectionFlowLayout.swift
//  TruckFinder
//
//  Created by Ginny Pennekamp on 5/5/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit

extension PhotoViewController {
    
    // MARK: - Collection View Flow
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // set up custom flow
        if flowLayout != nil {
            if self.isSmall {
                fitCollectionFlowToSmallSize(size)
            } else {
                fitCollectionFlowToBigSize(size)
            }
        }
    }
    
    func fitCollectionFlowToSmallSize(_ size: CGSize) {
        // determine the number of and spacing between collection items
        let space: CGFloat = 3.0
        // adjust dimension to width and height of screen
        let dimension = size.width >= size.height ? (size.width - (5*space))/5.0 : (size.width - (2*space))/3.0
        // set up custom flow
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    func fitCollectionFlowToBigSize(_ size: CGSize) {
        // determine the number of and spacing between collection items
        let space: CGFloat = 3.0
        // adjust dimension to width and height of screen
        let dimension = size.width >= size.height ? (size.width - (3*space))/3.0 : (size.width - (3*space))/2.0
        // set up custom flow
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}
