//
//  Meal.swift
//  Meal Timeline
//
//  Created by Leandro Morgado on 7/25/15.
//  Copyright (c) 2015 Henrique do Prado Linhares. All rights reserved.
//

import UIKit
import CoreData

@objc(Meal)
class Meal: NSManagedObject {

    var uiImage: UIImage?
    @NSManaged var image: NSData
    @NSManaged var timeStamp: NSDate
    @NSManaged var title: String
    @NSManaged var body: String
    @NSManaged var healthyValue: NSNumber
    @NSManaged var lovelyValue: NSNumber

}
