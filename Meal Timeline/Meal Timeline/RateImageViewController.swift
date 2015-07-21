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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonAct(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
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
