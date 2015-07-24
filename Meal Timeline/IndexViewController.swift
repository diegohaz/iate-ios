//
//  IndexViewController.swift
//  Meal Timeline
//
//  Created by Henrique do Prado Linhares on 23/07/15.
//  Copyright (c) 2015 Henrique do Prado Linhares. All rights reserved.
//

import UIKit
import MobileCoreServices

class IndexViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    var image:UIImage?
    var newMedia:Bool?
    
    var todayMeals = [Meal]()
    
    @IBOutlet weak var todayCollectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayCollectionView.registerNib(UINib(nibName: "MealCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MealCell")
        
        todayMeals.append(Meal(pimage: UIImage(), pdate: NSDate(), phealthyValue: 0.3, plovelyValue: 0.5))
        todayMeals.append(Meal(pimage: UIImage(), pdate: NSDate(), phealthyValue: 0.74, plovelyValue: 0.5))
        todayMeals.append(Meal(pimage: UIImage(), pdate: NSDate(), phealthyValue: 0.3, plovelyValue: 0.5))
        todayMeals.append(Meal(pimage: UIImage(), pdate: NSDate(), phealthyValue: 0.3, plovelyValue: 0.5))
        todayCollectionView.reloadData()
    }
    
    
    @IBAction func plusButtonAct(sender: AnyObject) {
        let actionSheet = UIActionSheet(title: "New Picture", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Picture", "Camera Roll")
            //actionSheet.destructiveButtonIndex = -1
        actionSheet.showInView(self.view)
    }
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 1){
        self.useCamera()
        } else if (buttonIndex == 2){
            self.useCameraRoll()
        }
        
        
    }
    

    func useCameraRoll(){
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia=false
        }
        
    }
    
    func useCamera(){
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = true
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        if mediaType == (kUTTypeImage as! String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            self.image = image
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            }
        }
        self.performSegueWithIdentifier("goRate", sender: self)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goRate"){
            var svc = segue.destinationViewController as! RateImageViewController
            svc.image = self.image
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayMeals.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MealCell", forIndexPath: indexPath) as! MealCollectionViewCell
        let meal = todayMeals[indexPath.row]
        
        // Configure the cell
        dump(cell)
        
        return cell
    }

}
