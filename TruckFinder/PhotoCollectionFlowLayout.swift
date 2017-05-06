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
                fitCollectionFlowToSize(size, numberHorizontal: 5.0, numberVertical: 3.0)
            } else {
                fitCollectionFlowToSize(size, numberHorizontal: 3.0, numberVertical: 2.0)
            }
        }
    }
    
    func fitCollectionFlowToSize(_ size: CGSize, numberHorizontal: CGFloat, numberVertical: CGFloat) {
        // determine the number of and spacing between collection items
        let space: CGFloat = 3.0
        // adjust dimension to width and height of screen
        let dimension = size.width >= size.height ? (size.width - (5*space))/numberHorizontal : (size.width - (2*space))/numberVertical
        // set up custom flow
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}
