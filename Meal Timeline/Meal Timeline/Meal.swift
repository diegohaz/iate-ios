//
//  Meal.swift
//  Meal Timeline
//
//  Created by Henrique do Prado Linhares on 21/07/15.
//  Copyright (c) 2015 Henrique do Prado Linhares. All rights reserved.
//

import UIKit

class Meal: NSObject {
    var name:String?
    var descript:String?
    var image:UIImage?
    var date:NSDate?
    var healthyValue:Float?
    var lovelyValue:Float?
    

 
    
    init(pname :String, pdescript :String, pimage :UIImage, pdate :NSDate, phealthyValue :Float, plovelyValue:Float){
        self.name = pname
        self.descript = pdescript
        self.image = pimage
        self.date = pdate
        self.healthyValue = phealthyValue
        self.lovelyValue = plovelyValue
    }
    
    override init(){
    
    }
    
}
