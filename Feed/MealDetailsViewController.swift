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
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    var meal:Meal!
    var isEditing:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        
        view.addGestureRecognizer(tap)
        

        self.imageVIew.image =  ImageTransformer().reverseTransformedValue(self.meal?.image) as? UIImage
        
        
        
        self.healthySlider.value = self.meal.healthyValue as! Float
        self.healthySlider.enabled = false
        
        self.lovelySlider.value = self.meal.lovelyValue as! Float
        self.lovelySlider.enabled = false
        
        self.bodyTextView.text = self.meal?.body
        self.bodyTextView.editable = false
        
        self.isEditing = false
    }


    
    @IBAction func editButtonAction(sender: UIButton) {
        if (self.isEditing == true){//if is editing
            self.isEditing = false
            self.bodyTextView.editable = false
            self.healthySlider.enabled = false
            self.lovelySlider.enabled = false
            self.deleteButton.hidden = false
            self.doneButton.hidden = false
            self.editButton.setTitle("Edit", forState: UIControlState.Normal)
            self.meal.healthyValue = self.healthySlider.value
            self.meal.lovelyValue = self.lovelySlider.value
            self.meal.body = self.bodyTextView.text
            //Must save it into the Singleton!
            MealDB().save(self.meal)
            
        } else if (self.isEditing == false) {//if is not editing
            self.isEditing = true
            self.bodyTextView.editable = true
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
    
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if (self.bodyTextView.text == "Description (optional)"){
            self.bodyTextView.text = nil
        }
        self.view.frame.origin.y -= 150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if (self.bodyTextView.text == "" || self.bodyTextView.text == " "){
            self.bodyTextView.text = "Description (optional)"
        }
        self.view.frame.origin.y += 150
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
