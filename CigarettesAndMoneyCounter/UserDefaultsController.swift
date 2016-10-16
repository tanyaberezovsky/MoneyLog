//
//  UserDefaultsController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 10/9/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//

import UIKit


class UserDefaultsController: GlobalUIViewController,TableLevelsControllerDelegate {
  // MARK: Properties
    @IBOutlet weak var reason: UIButton!
   
    var reasonText:String!
    var tempValue:String!
     

    @IBOutlet var dailyGoal: UITextField!
    
    @IBOutlet weak var minimalMode: UISwitch!
    var minimalModeOn:Bool!
    var myDelegate:UserDefaultsControllerDelegate? = nil
    
    override func viewDidLoad() {
        loadGraphicsSettings()
        LoadDefaultValues()
        
        gradientBackgroundRegular()
        
    }
    
    override func gradientBackgroundRegular() {
        self.view.backgroundColor = UIColor.clear
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        
        
        gradient.colors = ColorTemplates.purpleGrayCGColor()
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    
    @IBAction func dailyLimitEditingBegin(_ sender: UITextField) {
        tempValue = sender.text
        sender.text = ""
    }
    @IBAction func dailyLimitEditingEnd(_ sender: UITextField) {
        if (sender.text == "")
        {
            sender.text = tempValue
        }
    }
    
    
  
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            SaveDafaultsTouch()
        }
    }

    
    func SaveDafaultsTouch() {
        let defaults = UserDefaultsDataController()
        
        let userDefaults:UserDefaults = defaults.loadUserDefaults()
        
        
            userDefaults.averageCostOfOneCigarett = userDefaults.averageCostOfOnePack / Double(userDefaults.amountOfCigarettsInOnePack)
        
            if isNumeric(dailyGoal.text!){
                userDefaults.dailyGoal = Int(dailyGoal.text!)!}
        

        
            if (reasonText != nil)
            {
                userDefaults.reason = reasonText
            }
            if(minimalModeOn != nil){
                userDefaults.minimalModeOn = minimalModeOn
            }
        
            defaults.saveUserDefaults(userDefaults)
        
        
        if(myDelegate != nil){
            myDelegate!.ReloadUserDefaults()
        }
    }
    
    func barButtonItemClicked(){
        if(myDelegate != nil){
            myDelegate!.ReloadUserDefaults()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    
    //init variable and set segueid into it
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueNames.segueCauseOfSmoking{
            let vc = segue.destination as! TableLavels
            vc.segueSourceName = segue.identifier
            vc.myDelegate = self
        }
     
    }
    
    
    
    //++++++++++++++++++++++++++++++++++++
    //  load Graphics Settings
    //++++++++++++++++++++++++++++++++++++
    func loadGraphicsSettings() {
        
        //set button look like text field
        var layerLevelAsNeeded: CALayer
        
        //set button look like text field
        layerLevelAsNeeded = reason.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.cgColor
        
        
        
        layerLevelAsNeeded = dailyGoal.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.cgColor
        
     
    }
    
    //++++++++++++++++++++++++++++++++++++
    //  Load Default Values from controller
    //++++++++++++++++++++++++++++++++++++
    func LoadDefaultValues(){
        let defaults = UserDefaultsDataController()
        let userDefaults:UserDefaults = defaults.loadUserDefaults()
        
        
        dailyGoal.text = String(userDefaults.dailyGoal)
        
        
        reasonText = String(userDefaults.reason)
        
        reason.setTitle(reasonText, for: UIControlState())
        
        
    }
    
    /*
    delegated function from TableLavels.swift
    received selected row value from TableLevels and set it to apropriate field
    */
    func myColumnDidSelected(_ controller: TableLavels, text: String, segueName: String) {
        
        if segueName == segueNames.segueCauseOfSmoking && !text.isEmpty {
            reasonText = text;
            reason.setTitle(reasonText, for: UIControlState())
        }
        
      
        _ = controller.navigationController?.popViewController(animated: true)
    }
    
}


protocol UserDefaultsControllerDelegate{
    func ReloadUserDefaults()
}
