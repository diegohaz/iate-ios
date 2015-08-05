//
//  ImgPickerViewController.swift
//  i Ate
//
//  Created by Henrique do Prado Linhares on 05/08/15.
//  Copyright (c) 2015 Henrique do Prado Linhares. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary

class ImgPickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var pickerMode:Int?
    var newMedia:Bool?
    var image:UIImage?
    var imageDate:NSDate?
    var shouldReturnToIndex = false
    var shouldPerformSegue = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
    self.activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if (self.shouldPerformSegue == true){
        self.shouldPerformSegue = false
        self.performSegueWithIdentifier("goRate", sender: self)
        }
        
        if (self.shouldReturnToIndex == true){
            self.shouldReturnToIndex = false
            self.performSegueWithIdentifier("backToIndex", sender: self)
        }
        
        super.viewDidLoad()
        if (self.pickerMode == 1){
            self.useCamera()
        } else if (self.pickerMode == 2){
            self.useCameraRoll()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func useCameraRoll(){
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.SavedPhotosAlbum
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
                self.shouldPerformSegue = true
                
            } else {
                //se pegou a foto do camera roll
                
                // Começa a parte que recupera a NSDate da imagem selecionada da camera roll
                let library = ALAssetsLibrary()
                var url: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
                
                
                library.assetForURL(url, resultBlock: { (asset: ALAsset!) in
                    if asset.valueForProperty(ALAssetPropertyDate) != nil {
                        let imagecRollDate = (asset.valueForProperty(ALAssetPropertyDate) as! NSDate!)
                        self.imageDate = imagecRollDate
                        self.shouldPerformSegue = true
                    }
                    },
                    failureBlock: { (error: NSError!) in
                        println(error.localizedDescription)
                })
                // Termina a parte que recupera a NSDate da imagem selecionada da camera roll
                
            }
        }
        
        println("Date: \(self.imageDate)")
        
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
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.shouldReturnToIndex = true
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goRate"){
        var svc = segue.destinationViewController as! RateImageViewController
        svc.image = self.image
        svc.imageDate = self.imageDate
        }
    }


}
