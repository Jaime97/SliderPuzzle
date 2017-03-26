//
//  GameViewController.swift
//  SliderPuzzle
//
//  Created by MAC on 24/3/17.
//  Copyright © 2017 Jaime Alcántara. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: ------- IBOutlets properties ---------
    
    @IBOutlet weak var shadowView: UIView!
    
    
    @IBOutlet weak var endView: UIView!
    
    @IBOutlet weak var difficultyLabel: UILabel!
    
    
    @IBOutlet weak var movementsLabel: UILabel!
    
    var imageSelected:String = String()

    // I'll get the data from the model
    let gameModel: GameModel = GameModel()
    
    
    var gameTiles: [Tile] = [Tile]()
    
    var emptyTile: Int = 0
    var numberOfTilesPerSection: Int = 2
    
    
    var positions: [CGPoint] = [CGPoint]()
    
    var emptyBigger: Bool = false
    var tilesMovedIndex: [Int] = [Int]()
    
    var tileValue:CGFloat = 0
    
    var movementLimit:CGFloat = 0
    
    var movements:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve the data from the model to fill the tiles
        let originalImage: UIImage = UIImage(named: imageSelected)!
        self.gameTiles = self.gameModel.retrieveTilesData(image: originalImage, into: self.numberOfTilesPerSection)
        
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
                
                let selectedTile: Tile = self.gameTiles[i*self.numberOfTilesPerSection + j]
                selectedTile.imageView.tag = i*self.numberOfTilesPerSection + j
                
                let widthPosition:CGFloat = CGFloat(j) * (self.tileValue + 4) + 4
                
                
                // I save the position of the tile in the view
                var coord:CGPoint = CGPoint()
                coord.x = widthPosition + self.tileValue / 2
                coord.y = heightPosition + self.tileValue / 2
                self.positions.append(coord)
                
                if i*self.numberOfTilesPerSection + j != self.emptyTile {
                    let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                    panRecognizer.delegate = self
                    tapRecognizer.delegate = self
                    selectedTile.imageView.isUserInteractionEnabled = true
                    selectedTile.imageView.addGestureRecognizer(panRecognizer)
                    selectedTile.imageView.addGestureRecognizer(tapRecognizer)
                
                
                    view.addSubview(selectedTile.imageView)
                
                    let verConstrait = NSLayoutConstraint(item: selectedTile.imageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .top, multiplier: 1, constant: heightPosition)
                
                    let horConstrait = NSLayoutConstraint(item: selectedTile.imageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .leading, multiplier: 1, constant: widthPosition)
                
                    
                    let heightConstrait = NSLayoutConstraint(item: selectedTile.imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.tileValue)
                    let widthConstrait = NSLayoutConstraint(item: selectedTile.imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: . notAnAttribute, multiplier: 1, constant: self.tileValue)
            
                    view.addConstraints([horConstrait, verConstrait, heightConstrait, widthConstrait])
                    

                    
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
            if sameColumn(imageIndex: imageIndex){
                // It tryes to go up
                if translation.y < 0 && canIMove(imageIndex: imageIndex, viewCenter: view.center, direction: 0) {
                    performMovement(movementX: 0, movementY: limitingMovement(movementTryed: view.center.y+translation.y, positiveMovement: false)-view.center.y)
                }
                // It tryes to go down
                if translation.y > 0 && canIMove(imageIndex: imageIndex, viewCenter: view.center, direction: 1) {
                    performMovement(movementX: 0, movementY: limitingMovement(movementTryed: view.center.y + translation.y, positiveMovement: true)-view.center.y)
                }
            }
            if sameRow(imageIndex: imageIndex) {
                // It tryes to go to the left
                if translation.x < 0 && canIMove(imageIndex: imageIndex, viewCenter: view.center, direction: 2) {
                    performMovement(movementX: limitingMovement(movementTryed: view.center.x + translation.x, positiveMovement: false) - view.center.x, movementY: 0)
                }
                // It tryes to go to the right
                if translation.x > 0 && canIMove(imageIndex: imageIndex, viewCenter: view.center, direction: 3) {
                    performMovement(movementX: limitingMovement(movementTryed: view.center.x + translation.x, positiveMovement: true) - view.center.x, movementY: 0)
                }
            }

            if sender.state == UIGestureRecognizerState.ended {
                
                finishingMovement(imageIndex:imageIndex)
                if checkIfEnds() {
                    showEndView()
                }
                
            }
            
        }
        sender.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        
        
        
    }
    
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        
        if sender.view != nil {
            let imageIndex:Int = (sender.view?.tag)!
            self.emptyBigger = false
            if self.positions[self.emptyTile].x+self.positions[self.emptyTile].y > self.positions[imageIndex].x+self.positions[imageIndex].y {
                self.emptyBigger = true
            }
            calculateTilesMoved(imageIndex: imageIndex)
            
            if sameColumn(imageIndex: imageIndex) && imageIndex > self.emptyTile {
                performAutomaticMovement(movement: -self.numberOfTilesPerSection)
                
            } else if sameColumn(imageIndex: imageIndex) && imageIndex < self.emptyTile {
                performAutomaticMovement(movement: self.numberOfTilesPerSection)
                
            }else if sameRow(imageIndex: imageIndex) && imageIndex > self.emptyTile {
                performAutomaticMovement(movement: -1)
                
            } else if sameRow(imageIndex: imageIndex) && imageIndex < self.emptyTile {
                performAutomaticMovement(movement: 1)
            }
            
            finishingMovement(imageIndex:imageIndex)
            if checkIfEnds() {
                showEndView()
            }
            
            
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
            // Wants to go up
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
            
            break
        case 1:
            // Wants to go down
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
            
            break
        case 2:
            // Wants to go left
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
            
            break
        case 3:
            // Wants to go right
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
            
            
            break
            
        default:
            break
        }
        
        return canMove
    }
    
    func sameColumn(imageIndex:Int) -> Bool {
        return imageIndex % self.numberOfTilesPerSection == self.emptyTile % self.numberOfTilesPerSection
    }
    
    func sameRow(imageIndex:Int) -> Bool {
        return imageIndex / self.numberOfTilesPerSection == self.emptyTile / self.numberOfTilesPerSection
    }
    
    
    // MARK: --------- Move methods ----------
    
    func performMovement(movementX:CGFloat, movementY:CGFloat) {
        for i in 0...self.tilesMovedIndex.count - 1 {
            let view = self.gameTiles[self.tilesMovedIndex[i]].imageView
            view.center = CGPoint(x:movementX + view.center.x, y:movementY + view.center.y)
        }
        
    }
    
    func performAutomaticMovement(movement: Int){
        
        for i in 0...self.tilesMovedIndex.count - 1 {
            let view = self.gameTiles[self.tilesMovedIndex[i]].imageView
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                view.center = self.positions[self.tilesMovedIndex[i]+movement]
            }, completion: nil)
        }
    }
    
    
    
    func finishingMovement(imageIndex:Int) {
        
        let previousTag:Int = self.gameTiles[imageIndex].imageView.tag
        
        for i in 0...self.tilesMovedIndex.count - 1 {
            let view = self.gameTiles[self.tilesMovedIndex[i]].imageView
            let selectedEndIndex:Int = nearestIndex(point: view.center)
            let nearestPoint:CGPoint = self.positions[selectedEndIndex]
            view.tag = selectedEndIndex
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                
                view.center = nearestPoint
                
            }, completion: nil)

        }
        if previousTag != self.gameTiles[imageIndex].imageView.tag {
            //The views has moved, so the empty space have to change
            self.movements += 1
            self.gameTiles[self.emptyTile].imageView.tag = imageIndex
            self.emptyTile = imageIndex
            self.gameTiles = self.gameModel.reorder(gameTiles: self.gameTiles)
        }
        
    }
    
    
    //MARK: ---------- Other methods ----------
    
    
    func checkIfEnds() -> Bool {
        
        var endOfGame:Bool = true
        for i in 0...self.gameTiles.count-1 {
            if self.gameTiles[i].correctPosition != self.gameTiles[i].imageView.tag {
                endOfGame = false
            }
            
        }
        return endOfGame
        
    }
    
    func showEndView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            self.difficultyLabel.text = ("Difficulty: " + String(self.numberOfTilesPerSection) + "x" + String(self.numberOfTilesPerSection))
            self.movementsLabel.text = ("Movements: " + String(self.movements))
            
            self.shadowView.alpha = 1
            self.endView.alpha = 1
            
            self.view.bringSubview(toFront: self.shadowView)
            self.view.bringSubview(toFront: self.endView)
            
            
            
        }, completion: nil)
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y);
    }
    
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to));
    }
    
    func nearestIndex(point:CGPoint) -> Int {
        var bestPoint:CGPoint = self.positions[0]
        var bestIndex:Int = 0
        for i in 0...self.positions.count - 1 {
            let currentPoint:CGPoint = self.positions[i]
            if CGPointDistance(from: point, to: currentPoint) < CGPointDistance(from: point, to: bestPoint){
                bestPoint = currentPoint
                bestIndex = i
            }
            
            
        }
        return bestIndex
        
    }


}
