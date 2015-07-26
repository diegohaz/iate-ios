//
//  DayCircleView.swift
//  Meal Timeline
//
//  Created by Diego Haz on 7/23/15.
//  Copyright (c) 2015 Henrique do Prado Linhares. All rights reserved.
//

import UIKit

class DayCircleView: UIView {
    
    var healthy = 0.75
    var lovely = 0.25

    override func drawRect(rect: CGRect) {
        let stroke: CGFloat = bounds.width/20
        let width = bounds.width - stroke
        let height = bounds.height - stroke
        var path = UIBezierPath(roundedRect: CGRectMake(stroke/2, stroke/2, width, height), byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: width/2, height: height/2))
        
        UIColor(white: 0, alpha: 0.2).setStroke()
        path.lineWidth = stroke
        path.stroke()
        
        var healthyPath = UIBezierPath(arcCenter: CGPoint(x: width/2 + stroke/2, y: height/2 + stroke/2),
            radius: max(width, height) / 2,
            startAngle: CGFloat(M_PI) / 2,
            endAngle: CGFloat(healthy * (270 - 90) + 90) * CGFloat(M_PI) / 180.0,
            clockwise: true)
        
        UIColor(red: 0, green: 169/255, blue: 157/255, alpha: 1).setStroke()
        healthyPath.lineCapStyle = kCGLineCapRound
        healthyPath.lineWidth = stroke
        healthyPath.stroke()
        
        var lovelyPath = UIBezierPath(arcCenter: CGPoint(x: width/2 + stroke/2, y: height/2 + stroke/2),
            radius: max(width, height) / 2,
            startAngle: CGFloat(M_PI) / 2,
            endAngle: CGFloat((1 - lovely) * 180 + 270) * CGFloat(M_PI) / 180.0,
            clockwise: false)
        
        UIColor(red: 212/255, green: 20/255, blue: 90/255, alpha: 1).setStroke()
        lovelyPath.lineCapStyle = kCGLineCapRound
        lovelyPath.lineWidth = stroke
        lovelyPath.stroke()
    }

}
