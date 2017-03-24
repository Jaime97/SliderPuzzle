//
//  GameModel.swift
//  SliderPuzzle
//
//  Created by MAC on 24/3/17.
//  Copyright © 2017 Jaime Alcántara. All rights reserved.
//

import UIKit

class GameModel: NSObject {
    
    func createDataFromImage(gameSize: Int) -> [Cellinfo] {
        var gameCells: [Cellinfo] = [Cellinfo]()
        
        let originalImage: UIImage = UIImage(named: "hot-air-balloon")!
        
        
        let cellSize = Int(originalImage.size.height) / (gameSize * 3)
        
        for i in 0...gameSize {
            for p in 0...gameSize {
                let cell:Cellinfo = Cellinfo()
                cell.xIndex = i
                cell.yIndex = p
                let tmpImgRef: CGImage = originalImage.CGImage!
                
                let rect: CGImage = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(CGFloat(i * cellSize), CGFloat(p * cellSize), CGFloat(cellSize), CGFloat(cellSize)))!
                
                cell.image = UIImage(CGImage: rect)
                gameCells.append(cell)
                
            }
        }
        
        return gameCells
        
    }
    
    
    

}



