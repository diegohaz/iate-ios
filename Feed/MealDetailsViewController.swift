//
//  MealDetailsViewController.swift
//  Meal Timeline
//
//  Created by Henrique do Prado Linhares on 25/07/15.
//  Copyright (c) 2015 Henrique do Prado Linhares. All rights reserved.
//

import UIKit

class MealDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var imageVIew: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!

    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var healthySlider: UISlider!
    
    @IBOutlet weak var lovelySlider: UISlider!
    
    var meal:Meal!
    var isEditing:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

       // self.imageVIew.image = self.meal?.image
        self.imageVIew.image = UIImage(named: "Symbol")
        
        self.healthySlider.value = self.meal.healthyValue as! Float
        self.healthySlider.enabled = false
        
        self.lovelySlider.value = self.meal.lovelyValue as! Float
        self.lovelySlider.enabled = false
        
        self.isEditing = false
    }


    
    @IBAction func editButtonAction(sender: UIButton) {
        if (self.isEditing == true){//if is editing
            self.isEditing = false
            self.healthySlider.enabled = false
            self.lovelySlider.enabled = false
            self.deleteButton.hidden = false
            self.doneButton.hidden = false
            self.editButton.setTitle("Edit", forState: UIControlState.Normal)
            self.meal.healthyValue = self.healthySlider.value
            self.meal.lovelyValue = self.lovelySlider.value
            //Must save it into the Singleton!
            
        } else if (self.isEditing == false) {//if is not editing
            self.isEditing = true
            self.deleteButton.hidden = true
            self.doneButton.hidden = true
            self.healthySlider.enabled = true
            self.lovelySlider.enabled = true
            self.editButton.setTitle("Save", forState: UIControlState.Normal)
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doneButtonAct(sender: UIButton) {
        self.performSegueWithIdentifier("backToIndex", sender: self)
    }

    
    @IBAction func deleteButtonAct(sender: UIButton) {
        MealDB().delete(self.meal)
        self.performSegueWithIdentifier("backToIndex", sender: self)
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
