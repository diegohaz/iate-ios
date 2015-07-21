//
//  RateImageViewController.swift
//  Meal Timeline
//
//  Created by Henrique do Prado Linhares on 21/07/15.
//  Copyright (c) 2015 Henrique do Prado Linhares. All rights reserved.
//

import UIKit

class RateImageViewController: UIViewController {

 
    var image:UIImage?
    
    @IBOutlet weak var healthySlider: UISlider!
    
    @IBOutlet weak var lovelySlider: UISlider!

    @IBOutlet weak var imageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = self.image
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonAct(sender: UIButton) {
        
        var data:[Meal] = AppData.sharedInstance.getData()
        
        var mealInstance:Meal
        mealInstance = Meal()
        mealInstance.image = self.image!
        mealInstance.healthyValue = self.healthySlider.value
        mealInstance.lovelyValue = self.lovelySlider.value
        
       data.append(mealInstance)
        
        println("data size: ")
        println(data.count)
        
        AppData.sharedInstance.setData(data)
        
    
        
        // SAVE INFO !
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
