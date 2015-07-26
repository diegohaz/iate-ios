//
//  MealCollectionViewCell.swift
//  Meal Timeline
//
//  Created by Diego Haz on 7/24/15.
//  Copyright (c) 2015 Henrique do Prado Linhares. All rights reserved.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var circle: DayCircleView!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = imageView.bounds.width/2
        
    }
    
    func setHealthyLovely(#healthy: Float, lovely: Float) {
        self.circle.healthy = healthy
        self.circle.lovely = lovely
        self.circle.setNeedsDisplay()
    }
    
    func setMealTime(mealTime: NSDate) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm"
        
        time.text = formatter.stringFromDate(mealTime)
    }

}
