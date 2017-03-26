//
//  GameViewController.swift
//  SliderPuzzle
//
//  Created by MAC on 24/3/17.
//  Copyright © 2017 Jaime Alcántara. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate {

    // I'll get the data from the model
    let gameModel: GameModel = GameModel()
    
    
    var gameTiles: [Tile] = [Tile]()
    
    var emptyTile: Int = 0
    var numberOfTilesPerSection: Int = 4
    
    struct coordinate{
        var x: CGFloat
        var y: CGFloat
    }
    
    var positions: [coordinate] = [coordinate]()
    
    var emptyBigger: Bool = false
    var tilesMovedIndex: [Int] = [Int]()
    
    var tileValue:CGFloat = 0
    
    var movementLimit:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve the data from the model to fill the tiles
        let originalImage: UIImage = UIImage(named: "beach-artwork")!
        self.gameTiles = self.gameModel.retrieveTilesData(image: originalImage, into: 4)
        
        // Chosing the empty tile randomly
        self.emptyTile = Int(arc4random_uniform(UInt32(self.gameTiles.count)))
        
        //Displaying the tiles
        layoutTiles()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // This method will use the data from the model to display the images
    func layoutTiles(){
        
        // Calculating the dimensions of a single tile
        self.tileValue = (view.frame.size.width - CGFloat((self.numberOfTilesPerSection + 1) * 4)) / CGFloat(self.numberOfTilesPerSection)
        
        
        
        // Displaying the grid. Since I will let different sizes in the game (4x4, 5x5, etc) I will create
        // the constraints programmatically
        for i in 0...self.numberOfTilesPerSection - 1 {
            
            let heightPosition:CGFloat = CGFloat(i) * (self.tileValue + 4) + view.frame.size.width/4
            
            for j in 0...self.numberOfTilesPerSection - 1 {
                
                let selectedTile: Tile = self.gameTiles[i*4 + j]
                selectedTile.imageView.tag = i*4 + j
                
                let widthPosition:CGFloat = CGFloat(j) * (self.tileValue + 4) + 4
                
                
                // I save the position of the tile in the view
                var coord:coordinate = coordinate(x: 0,y: 0)
                coord.x = widthPosition + self.tileValue / 2
                coord.y = heightPosition + self.tileValue / 2
                self.positions.append(coord)
                
                if i*4 + j != self.emptyTile {
                    let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                    recognizer.delegate = self
                    selectedTile.imageView.isUserInteractionEnabled = true
                    selectedTile.imageView.addGestureRecognizer(recognizer)
                
                
                    view.addSubview(selectedTile.imageView)
                
                    let verConstrait = NSLayoutConstraint(item: selectedTile.imageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .top, multiplier: 1, constant: heightPosition)
                
                    let horConstrait = NSLayoutConstraint(item: selectedTile.imageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .leading, multiplier: 1, constant: widthPosition)
                
                    
                    let heightConstrait = NSLayoutConstraint(item: selectedTile.imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.tileValue)
                    let widthConstrait = NSLayoutConstraint(item: selectedTile.imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: . notAnAttribute, multiplier: 1, constant: self.tileValue)
            
                    view.addConstraints([horConstrait, verConstrait, heightConstrait, widthConstrait])
                    
                    
                    selectedTile.actualPosition.dimX = j
                    selectedTile.actualPosition.dimY = i
                    
                }
            }
        
        }
    }
    
    
    // MARK: --------- Gesture methods ----------
    
    
    func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        if let view = sender.view {
            let imageIndex:Int = (sender.view?.tag)!
            if sender.state == UIGestureRecognizerState.began {
                self.emptyBigger = false
                if self.positions[self.emptyTile].x+self.positions[self.emptyTile].y > self.positions[imageIndex].x+self.positions[imageIndex].y {
                    self.emptyBigger = true
                }
                calculateTilesMoved(imageIndex: imageIndex)
                
            }
        
            // It tryes to go up
            if translation.y < 0 && canIMove(imageIndex: imageIndex, viewCenter: view.center, direction: 0) {
                performMovement(movementX: 0, movementY: limitingMovement(movementTryed: view.center.y+translation.y, positiveMovement: false)-view.center.y)
            }
            // It tryes to go down
            if translation.y > 0 && canIMove(imageIndex: imageIndex, viewCenter: view.center, direction: 1) {
                performMovement(movementX: 0, movementY: limitingMovement(movementTryed: view.center.y + translation.y, positiveMovement: true)-view.center.y)
            }
            // It tryes to go to the left
            if translation.x < 0 && canIMove(imageIndex: imageIndex, viewCenter: view.center, direction: 2) {
                performMovement(movementX: limitingMovement(movementTryed: view.center.x + translation.x, positiveMovement: false) - view.center.x, movementY: 0)
            }
            // It tryes to go to the right
            if translation.x > 0 && canIMove(imageIndex: imageIndex, viewCenter: view.center, direction: 3) {
                performMovement(movementX: limitingMovement(movementTryed: view.center.x + translation.x, positiveMovement: true) - view.center.x, movementY: 0)
            }

            
            
        }
        sender.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        
        if sender.state == UIGestureRecognizerState.ended {
            
        
        }
        
    }
    
    
    // MARK: --------- Preparing to move methods ----------
    
    
    // Since the movement could be greater than expected (and pass the empty tyle) this method control the maximum movement
    func limitingMovement(movementTryed: CGFloat, positiveMovement: Bool) -> CGFloat {
        var finalMovement:CGFloat = movementTryed
        let limit:CGFloat = self.movementLimit
        
        if movementTryed > limit && positiveMovement {
           finalMovement = limit
        }
        else if movementTryed < limit && !positiveMovement {
                finalMovement = limit
        }
        
        return finalMovement
    }
    
    // This method will create an array with the tiles that has to move (the ones between the selected and the empty)
    func calculateTilesMoved(imageIndex:Int) {
        self.tilesMovedIndex = [Int]()
        var i:Int = min(imageIndex, self.emptyTile)
        let maximum:Int = max(imageIndex, self.emptyTile)
        self.tilesMovedIndex.append(imageIndex)
        if imageIndex % self.numberOfTilesPerSection == self.emptyTile % self.numberOfTilesPerSection{
            i += self.numberOfTilesPerSection
            while i < maximum {
                self.tilesMovedIndex.append(i)
                i += self.numberOfTilesPerSection
            }
        }
        else if imageIndex / self.numberOfTilesPerSection == self.emptyTile / self.numberOfTilesPerSection{
            i += 1
            while i < maximum {
                self.tilesMovedIndex.append(i)
                i += 1
            }
        }
    }
    
    
    // It will tell if the view can move depending on the position of the empty tyle
    func canIMove(imageIndex:Int, viewCenter: CGPoint, direction: Int) -> Bool{
        var canMove:Bool = false
        
        switch direction {
        case 0:
            if imageIndex % self.numberOfTilesPerSection == self.emptyTile % self.numberOfTilesPerSection{
                // The tiles are in the same column
                if self.emptyBigger {
                    self.movementLimit = self.positions[imageIndex].y
                    if self.positions[imageIndex].y < viewCenter.y {
                        canMove = true
                    }
                }
                else {
                    self.movementLimit = self.positions[imageIndex - self.numberOfTilesPerSection].y
                    if self.positions[imageIndex - self.numberOfTilesPerSection].y < viewCenter.y {
                        canMove = true
                    }
                }
            }
            
            break
        case 1:
            if imageIndex % self.numberOfTilesPerSection == self.emptyTile % self.numberOfTilesPerSection{
                // The tiles are in the same column
                if self.emptyBigger {
                    self.movementLimit = self.positions[imageIndex + self.numberOfTilesPerSection].y
                    if self.positions[imageIndex + self.numberOfTilesPerSection].y > viewCenter.y {
                        canMove = true
                    }
                }
                else {
                    self.movementLimit = self.positions[imageIndex].y
                    if self.positions[imageIndex].y > viewCenter.y {
                        canMove = true
                    }
                }
            }
            
            break
        case 2:
            if imageIndex / self.numberOfTilesPerSection == self.emptyTile / self.numberOfTilesPerSection{
                // The tiles are in the same row
                if self.emptyBigger {
                    self.movementLimit = self.positions[imageIndex].x
                    if self.positions[imageIndex].x < viewCenter.x {
                        canMove = true
                    }
                }
                else {
                    self.movementLimit = self.positions[imageIndex - 1].x
                    if self.positions[imageIndex - 1].x < viewCenter.x {
                        canMove = true
                    }
                }
            }
            
            break
        case 3:
            if imageIndex / self.numberOfTilesPerSection == self.emptyTile / self.numberOfTilesPerSection{
                // The tiles are in the same row
                if self.emptyBigger {
                    self.movementLimit = self.positions[imageIndex + 1].x
                    if self.positions[imageIndex + 1].x > viewCenter.x {
                        canMove = true
                    }
                }
                else {
                    self.movementLimit = self.positions[imageIndex].x
                    if self.positions[imageIndex].x > viewCenter.x {
                        canMove = true
                    }
                }
            }
            
            break
            
        default:
            break
        }
        
        return canMove
    }
    
    
    // MARK: --------- Move methods ----------
    
    func performMovement(movementX:CGFloat, movementY:CGFloat) {
        for i in 0...self.tilesMovedIndex.count - 1 {
            let view = self.gameTiles[self.tilesMovedIndex[i]].imageView
            view.center = CGPoint(x:movementX + view.center.x, y:movementY + view.center.y)
        }
        
    }


}
