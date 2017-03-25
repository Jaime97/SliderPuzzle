//
//  Tile.swift
//  SliderPuzzle
//
//  Created by Oscar on 25/03/2017.
//  Copyright © 2017 Jaime Alcántara. All rights reserved.
//

import UIKit

struct Position{
    var dimX: Int
    var dimY: Int
}

class Tile: UIView {
    
    var actualPosition:Position = Position(dimX: 0,dimY: 0)
    var correctPosition:Position = Position(dimX: 0,dimY: 0)
    
    var imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
