//
//  GameViewController.swift
//  SliderPuzzle
//
//  Created by MAC on 24/3/17.
//  Copyright © 2017 Jaime Alcántara. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let gameModel: GameModel = GameModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var gameCells: [Cellinfo] = [Cellinfo]()
    var emptyCell: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuring the grid
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
        // Retrieve the data from the model to fill the cells
        let originalImage: UIImage = UIImage(named: "hot-air-balloon")!
        self.gameCells = self.gameModel.retrieveTilesData(image: originalImage, into: 4)
        self.emptyCell = Int(arc4random_uniform(UInt32(self.gameCells.count)))
        
        // Register cell classes
        self.collectionView.registerNib(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "customGameCell")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        //Adjusting the size of cells to fill all the space
        return CGSize(width: self.collectionView.frame.width/4 - 6, height: self.collectionView.frame.width/4 - 6);
    }
    
    
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let totalIndex:Int = indexPath.row + indexPath.section * 4
        
        // Filling the cells with the info and images
        
        let cell: GameCell = collectionView.dequeueReusableCellWithReuseIdentifier("customGameCell", forIndexPath: indexPath) as! GameCell

        let image : UIImage = self.gameCells[totalIndex].image
        
        cell.cellImage.image = image
        
        if totalIndex == self.emptyCell {
            cell.cellImage.alpha = 0
        }
        // This propierties will tell us the correct position of te tile
        cell.xIndex = self.gameCells[totalIndex].xIndex
        cell.yIndex = self.gameCells[totalIndex].yIndex
        
        
        
        return cell
    }


}
