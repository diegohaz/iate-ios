//
//  MealCollectionViewCell.swift
//  Meal Timeline
//
//  Created by Diego Haz on 7/24/15.
//  Copyright (c) 2015 Henrique do Prado Linhares. All rights reserved.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = imageView.bounds.width/2
        
    }

}
