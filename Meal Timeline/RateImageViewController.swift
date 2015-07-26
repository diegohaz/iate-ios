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
    
    var imageDate:NSDate?
    
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
        
        println("Nova refeicao criada. ok!!")
        var mealInstance = MealDB.newInstance()
        
        // UIImage convertida para NSData. Por que no Banco todas as imagens estao no formato NSData.
        let newImageData = ImageTransformer().transformedValue(self.image) as! NSData
        
        // A partir daqui, vamos configurar a instancia refeicao. 
        //Lembre-se que a data da refeicao é criada quando salvamos no Banco (funcao save).
        mealInstance.image = newImageData
        mealInstance.healthyValue = self.healthySlider.value
        mealInstance.lovelyValue = self.lovelySlider.value
        
        // Salvando a nova refeicao
        MealDB().save(mealInstance)
        
        // Recuperando as refeicoes ja salvas
        let arrayMeals = MealDB().getMeals()
        
        println("BD size: ")
        println(arrayMeals.count)
        
        // Segue para o IndexViewController
         self.performSegueWithIdentifier("backToIndex", sender: self)

    }

    
    func DismissKeyboard(){
        view.endEditing(true)
    }

}
