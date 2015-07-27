//
//  IndexViewController.swift
//  Meal Timeline
//
//  Created by Henrique do Prado Linhares on 23/07/15.
//  Copyright (c) 2015 Henrique do Prado Linhares. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary

class IndexViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    var image:UIImage?
    var imageDate:NSDate?
    var newMedia:Bool?
    var selectedMeal:Meal?
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var todayCircle: DayCircleView!
    @IBOutlet weak var todayCircleHeight: NSLayoutConstraint!
    var todayMeals: Array<Meal> = []
    var pastMeals: [Array<Meal>] = []
    var pastDays: Array<NSDateComponents> = []
    var currentDay: Int = 0
    
    @IBOutlet weak var todayCollectionView: UICollectionView!
    @IBOutlet weak var pastCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayCollectionView.registerNib(UINib(nibName: "MealCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MealCell")
        todayMeals = MealDB().getMealsByDate(NSCalendar.currentCalendar().components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: NSDate()))
        
        var healthyCount: Float = 0
        var lovelyCount: Float = 0
        
        for meal in todayMeals {
            meal.uiImage = ImageTransformer().reverseTransformedValue(meal.image) as? UIImage
            healthyCount += meal.healthyValue as Float
            lovelyCount += meal.lovelyValue as Float
        }
        
        todayCircle.healthy = healthyCount / Float(todayMeals.count)
        todayCircle.lovely = lovelyCount / Float(todayMeals.count)
        todayCircle.setNeedsDisplay()
        todayCollectionView.reloadData()
        
        pastDays = MealDB().getEveryMealDates()
        
        for day in pastDays {
            let meals = MealDB().getMealsByDate(day)
            
            for meal in meals {
                meal.uiImage = ImageTransformer().reverseTransformedValue(meal.image) as? UIImage
            }
            
            pastMeals.append(meals)
        }
        
        pastCollectionView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (todayMeals.count > 0) {
            todayCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: todayMeals.count - 1, inSection: 0), atScrollPosition: .Right, animated: false)
        }
        
        if todayMeals.count == 0 {
            message.hidden = false
        } else {
            message.hidden = true
        }
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
            
            if (newMedia == true) { // se usou a camera para tirar a foto
                
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
                self.imageDate = NSDate() // pega a data atual
                self.performSegue()
                
            } else {
                //se pegou a foto do camera roll
                
                // Começa a parte que recupera a NSDate da imagem selecionada da camera roll
                let library = ALAssetsLibrary()
                var url: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
                
                
                library.assetForURL(url, resultBlock: { (asset: ALAsset!) in
                    if asset.valueForProperty(ALAssetPropertyDate) != nil {
                        let imagecRollDate = (asset.valueForProperty(ALAssetPropertyDate) as! NSDate!)
                        self.imageDate = imagecRollDate
                        self.performSegue()
                    }
                    },
                    failureBlock: { (error: NSError!) in
                        println(error.localizedDescription)
                })
                // Termina a parte que recupera a NSDate da imagem selecionada da camera roll
                
                
                
                println("passou pela recuperação da NSDate da imagem / roll")
            }
        }
        
        println("Date: \(self.imageDate)")
        
    }


    
    func performSegue(){
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
            svc.imageDate = self.imageDate
            svc.image = self.image
        }
        
        if (segue.identifier == "showMealDetails"){
            var svc = segue.destinationViewController as! MealDetailsViewController
            svc.meal = self.selectedMeal
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        if offset != 0 && offset < scrollView.contentSize.height - scrollView.bounds.height {
            let diff = 110 - offset * 1.5
            
            if diff > 0 && diff <= 110  {
                todayCircleHeight.constant = 70 + diff
            } else if diff <= 0 {
                todayCircleHeight.constant = 70
            } else {
                todayCircleHeight.constant = 180
            }
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return todayMeals.count
        } else if collectionView.tag == 1 {
            return pastDays.count
        } else {
            currentDay++
            
            if currentDay >= pastDays.count {
                currentDay = 0
            }
            
            return pastMeals[currentDay].count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let meal = todayMeals[indexPath.row]
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MealCell", forIndexPath: indexPath) as! MealCollectionViewCell
            
            cell.setHealthyLovely(healthy: meal.healthyValue as Float, lovely: meal.lovelyValue as Float)
            cell.setMealTime(meal.timeStamp)
            cell.imageView.image = meal.uiImage
            
            return cell
            
        } else if collectionView.tag == 1 {
            let day = pastDays[indexPath.row]
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DayCell", forIndexPath: indexPath) as! DayCollectionViewCell
            
            var healthyCount: Float = 0
            var lovelyCount: Float = 0
            
            for meal in pastMeals[indexPath.row] {
                healthyCount += Float(meal.healthyValue)
                lovelyCount += Float(meal.lovelyValue)
            }
            
            let calendar = NSCalendar.currentCalendar()
            let date = calendar.dateFromComponents(day)
            let formatter = NSDateFormatter()
            
            cell.dayCircle.healthy = healthyCount / Float(pastMeals[indexPath.row].count)
            cell.dayCircle.lovely = lovelyCount / Float(pastMeals[indexPath.row].count)
            cell.dayCircle.setNeedsDisplay()
            formatter.dateFormat = "dd"
            cell.day.text = formatter.stringFromDate(date!)
            formatter.dateFormat = "MMM"
            cell.month.text = formatter.stringFromDate(date!).uppercaseString
            
            return cell
        } else {
            collectionView.registerNib(UINib(nibName: "MealCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MealCell")
            let meal = pastMeals[currentDay][indexPath.row]
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MealCell", forIndexPath: indexPath) as! MealCollectionViewCell
            
            cell.setHealthyLovely(healthy: meal.healthyValue as Float, lovely: meal.lovelyValue as Float)
            cell.setMealTime(meal.timeStamp)
            cell.imageView.image = meal.uiImage
            
            return cell
        }
    }

    //quando seleciona um item, vai para a tela de Details
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("passou aqui! tag: \(collectionView.tag)")
        if (collectionView.tag==0){
            self.selectedMeal = todayMeals[indexPath.row]
            self.performSegueWithIdentifier("showMealDetails", sender: self)
        }
        if (collectionView.tag == 2 ){
           self.selectedMeal = pastMeals[currentDay][indexPath.row]
        self.performSegueWithIdentifier("showMealDetails", sender: self)
        }
    }

    

}
