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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configuring the grid
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.gameCells = self.gameModel.createDataFromImage(4)
        
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
        return CGSize(width: self.collectionView.frame.width/4, height: self.collectionView.frame.width/4);
    }
    
    
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: GameCell = collectionView.dequeueReusableCellWithReuseIdentifier("customGameCell", forIndexPath: indexPath) as! GameCell
        
        var image : UIImage = self.gameCells[indexPath.row + indexPath.section * 4].image
        
        cell.cellImage.image = image
        cell.xIndex = self.gameCells[indexPath.row + indexPath.section * 4].xIndex
        cell.yIndex = self.gameCells[indexPath.row + indexPath.section * 4].yIndex
        
        
        
        
        return cell
    }


}
