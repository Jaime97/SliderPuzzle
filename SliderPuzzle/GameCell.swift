//
//  GameCell.swift
//  SliderPuzzle
//
//  Created by MAC on 24/3/17.
//  Copyright © 2017 Jaime Alcántara. All rights reserved.
//

import UIKit


class GameCell: UICollectionViewCell {
    
    var xIndex:Int = 0
    var yIndex:Int = 0
    var isEmpty:Bool = false
    
    @IBOutlet weak var cellImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
