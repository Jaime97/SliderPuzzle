//
//  GameModel.swift
//  SliderPuzzle
//
//  Created by MAC on 24/3/17.
//  Copyright © 2017 Jaime Alcántara. All rights reserved.
//

import UIKit

class GameModel: NSObject {

    
    // This method will take the image and slice it in parts for the matrix
    func retrieveTilesData(image: UIImage, into howMany: Int) -> [Tile] {
        let scale = Int(image.scale)
        let width = Int(image.size.width / CGFloat(howMany))
        let height = Int(image.size.height / CGFloat(howMany))
        let cgImage = image.cgImage!
        //The array with all the info
        var gameCells: [Tile] = [Tile]()
        
        var adjustedHeight = height
        
        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(image.size.height) - y
            }
            var adjustedWidth = width
            var x = 0
            for column in 0 ..< howMany {
                let tile:Tile = Tile()
                tile.correctPosition.dimX = row
                tile.correctPosition.dimY = column
                
                if column == (howMany - 1) {
                    adjustedWidth = Int(image.size.width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCgImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                
                tile.imageView.image = UIImage(cgImage: tileCgImage, scale: image.scale, orientation: image.imageOrientation)
                gameCells.append(tile)
                x += width
            }
            y += height
        }
        
        // I disorder the tiles before retrieving them
        gameCells.shuffle()
        
        return gameCells
    }
    
    

}


// I've added an extension to the class Array to shuffle the elements.
// I will make use of it when ordering the tiles
extension Array {
    mutating func shuffle() {
        for i in 0 ..< (count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if i != j {
                swap(&self[i], &self[j])
            }
        }
    }
}



