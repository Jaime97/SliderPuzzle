//
//  Tile.swift
//  SliderPuzzle
//
//  Created by Oscar on 25/03/2017.
//  Copyright © 2017 Jaime Alcántara. All rights reserved.
//

import UIKit


class Tile: UIView {
    
    var correctPosition:Int = 0
    
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
