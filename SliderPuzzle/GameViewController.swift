//
//  GameViewController.swift
//  SliderPuzzle
//
//  Created by MAC on 24/3/17.
//  Copyright © 2017 Jaime Alcántara. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate {

    let gameModel: GameModel = GameModel()
    
    
    var gameTiles: [Tile] = [Tile]()
    var emptyTile: Int = 0
    var numberOfTilesPerSection: Int = 4
    
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
        let tileValue: CGFloat = (view.frame.size.width - CGFloat((self.numberOfTilesPerSection + 1) * 4)) / CGFloat(self.numberOfTilesPerSection)
        
        
        
        // Displaying the grid. Since I will let different sizes in the game (4x4, 5x5, etc) I will create
        // the constraints programmatically
        for i in 0...self.numberOfTilesPerSection - 1 {
            
            let heightPosition:CGFloat = CGFloat(i) * (tileValue + 4) + view.frame.size.width/4
            
            for j in 0...self.numberOfTilesPerSection - 1 {
                
                let selectedImage: UIImageView = self.gameTiles[i*4 + j].imageView
                selectedImage.tag = i*4 + j
                
                if i*4 + j != self.emptyTile {
                    let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                    recognizer.delegate = self
                    selectedImage.isUserInteractionEnabled = true
                    selectedImage.addGestureRecognizer(recognizer)
                    
                    let widthPosition:CGFloat = CGFloat(j) * (tileValue + 4) + 4
                
                    view.addSubview(selectedImage)
                
                    let verConstrait = NSLayoutConstraint(item: selectedImage, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .top, multiplier: 1, constant: heightPosition)
                
                    let horConstrait = NSLayoutConstraint(item: selectedImage, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .leading, multiplier: 1, constant: widthPosition)
                
                    
                    let heightConstrait = NSLayoutConstraint(item: selectedImage, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: tileValue)
                    let widthConstrait = NSLayoutConstraint(item: selectedImage, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: . notAnAttribute, multiplier: 1, constant: tileValue)
            
                    view.addConstraints([horConstrait, verConstrait, heightConstrait, widthConstrait])
                }
            }
        
        }
    }
    
    func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            let imageIndex:Int = (sender.view?.tag)!
            
            view.center = CGPoint(x:view.center.x, y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
    }
    
    
    func whereToMove(imageIndex:Int) -> Int {
        var direction:Int = 0
        
        
        return 0
    }


}
