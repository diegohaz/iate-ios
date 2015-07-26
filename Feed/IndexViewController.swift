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
    
    @IBOutlet weak var todayCircleHeight: NSLayoutConstraint!
    var todayMeals = [Meal]()
    var pastMeals  = [Meal]()
    
    @IBOutlet weak var todayCollectionView: UICollectionView!
    @IBOutlet weak var pastCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayCollectionView.registerNib(UINib(nibName: "MealCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MealCell")
        
        todayMeals = MealDB().getMeals()

        todayCollectionView.reloadData()
        
        pastMeals = MealDB().getMeals()
        
        pastCollectionView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        todayMeals = MealDB().getMeals()
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
        return todayMeals.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        
        if collectionView.tag == 0 {
            let meal = todayMeals[indexPath.row]
            var mycell = collectionView.dequeueReusableCellWithReuseIdentifier("MealCell", forIndexPath: indexPath) as! MealCollectionViewCell //GAMBI !!!!
            
            mycell.setHealthyLovely(healthy: meal.healthyValue as Float, lovely: meal.lovelyValue as Float)
            mycell.setMealTime(meal.timeStamp)
            mycell.imageView.image = ImageTransformer().reverseTransformedValue(meal.image) as? UIImage
            
            return mycell
            
        } else if collectionView.tag == 1 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("DayCell", forIndexPath: indexPath) as! UICollectionViewCell
        } else {
            collectionView.registerNib(UINib(nibName: "MealCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MealCell")
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("MealCell", forIndexPath: indexPath) as! MealCollectionViewCell
        }
        
        return cell
    }

    //quando seleciona um item, vai para a tela de Details
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (collectionView.tag==0){
            self.selectedMeal = todayMeals[indexPath.row]
            self.performSegueWithIdentifier("showMealDetails", sender: self)
        }
    }

    

}
