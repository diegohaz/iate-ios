//
//  Meal.swift
//  Meal Timeline
//
//  Created by Henrique do Prado Linhares on 21/07/15.
//  Copyright (c) 2015 Henrique do Prado Linhares. All rights reserved.
//

import UIKit

class Meal: NSObject {
    
    var image:UIImage?
    var date:NSDate?
    var healthyValue:Float?
    var lovelyValue:Float?
    

 
    
    init(pimage :UIImage, pdate :NSDate, phealthyValue :Float, plovelyValue:Float){
        self.image = pimage
        self.date = pdate
        self.healthyValue = phealthyValue
        self.lovelyValue = plovelyValue
    }
    
    override init(){
    
    }
    
}
