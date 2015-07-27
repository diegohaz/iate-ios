//
//  ImageTransformer.swift
//  Meal Timeline
//
//  Created by Leandro Morgado on 7/25/15.
//  Copyright (c) 2015 Henrique do Prado Linhares. All rights reserved.
//

import Foundation
import UIKit

class ImageTransformer : NSValueTransformer
{
    
    override class func transformedValueClass() -> AnyClass {
      
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
       
        return  true
    }
    
    // Converte imagem: NSDATA -> UImage. Complemento: cast "(...) as UImage"
    override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        
        if (value == nil) {
            return nil
        }
        
        return UIImage(data: value as! NSData)
    }
    
    // Converte imagem: UImage -> NSDATA. Complemento: cast "(...) as NSData"
    override func transformedValue(value: AnyObject?) -> AnyObject? {
     
        let image = value as? UIImage
        return UIImageJPEGRepresentation(image, 0.1)
    
    }
    
}

