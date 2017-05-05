# Truck Finder

"Truck Finder" is an app developed as a possible feature for my Udacity iOS Nanodegree final project, "Name That Truck." It would fulfill UICollectionView and API call requirements for that project by automatically pulling up a photo gallery for a type of truck, and saving the loaded images into Core Data for reuse. 

## Install

To check out my version of "Truck Finder":

1. Clone or download my repository:
` $ https://github.com/ginnypx1/TruckFinder.git `

2. Enter the "Truck Finder" directory:
` $ cd /TruckFinder-master/ `

3. Open "Truck Finder" in XCode:
` $ open TruckFinder.xcodeproj `

To run the project in xCode, you will need to add a Private.swift file with your Flickr API key information:

```
let YOUR_API_KEY = <YOUR_API_KEY>
```

## Instructions

Right now, "Truck Finder" automatically loads a set of 21 images based on a tag search passed in randomly for different collection views of trucks. You may see construction trucks, emergency trucks, farm trucks or big rigs.

To zoom in on an image, tap an image and the collection flow will change to bigger images. To reset to the smaller images, simply tap on another image.

The images can be reloaded by pressing the *More Trucks* button. 

## Technical Information

The Flickr API can be found at: https://www.flickr.com/services/api/

## Planned Utilization

When a player correctly guesses the identity of a certain truck, they will be able to press a button that allows them to see many more pictures of that type of truck. A collection of images for each type of truck will be stored in Core Data, which will allow the app to be much more useful in an offline mode.