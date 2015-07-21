//
//  AppData.swift
//  Meal Timeline
//
//  Created by Henrique do Prado Linhares on 21/07/15.
//  Copyright (c) 2015 Henrique do Prado Linhares. All rights reserved.
//

class AppData {
    static let sharedInstance = AppData()
    var data = [Meal]()

    func getData()->[Meal]{
    return data
    }
    
    func setData(var pdata:[Meal]){
    self.data = pdata
    }
}