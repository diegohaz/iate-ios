//
//  IndexViewController.swift
//  Meal Timeline
//
//  Created by Henrique do Prado Linhares on 23/07/15.
//  Copyright (c) 2015 Henrique do Prado Linhares. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController, UIActionSheetDelegate {

    @IBAction func plusButtonAct(sender: AnyObject) {
        let actionSheet = UIActionSheet(title: "New Picture", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Picture", "Camera Roll")
            //actionSheet.destructiveButtonIndex = -1
        actionSheet.showInView(self.view)
    }
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        println("clicou no indice \(buttonIndex)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
