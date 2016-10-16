//
//  popOverViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 02/03/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import UIKit

class popOverViewController: UIViewController, TableLevelsControllerDelegate
{
    //MARK: Properties
    var datePickerView  : UIDatePicker = UIDatePicker()
    
    var myDelegate:popOverControllerDelegate? = nil
    
    @IBOutlet weak var causeOfSmoking: UIButton!
    
    @IBOutlet weak var amount: UITextField!
    
    @IBOutlet weak var dateExpence: UITextField!
    
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var done: UIButton!
    var reasonText:String = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
        loadScreenGraphics()
        roundButtonConers()
        LoadDefaultValues()
    }
    func setNowDate(){
        let curentDate = Date()
        dateExpence.text = self.getStringDate(curentDate)
        datePickerView.date = curentDate
    }
    func getStringDate(_ dDate: Date)->String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        return dateFormatter.string(from: dDate)
    }

    func loadScreenGraphics()
    {
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        dateExpence.inputView = datePickerView
        //set selected date to text field
        datePickerView.addTarget(self, action: #selector(self.handleDatePicker(_:)),
                                 for: UIControlEvents.valueChanged)
        
        //set button look like text field
        var layerLevelAsNeeded: CALayer
       
        
        layerLevelAsNeeded = causeOfSmoking.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColor.lightGray.cgColor
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeAllKeyboards()
    }
    
    func closeAllKeyboards()
    {
        self.view.endEditing(true)
    }

    func roundButtonConers(){
        done.layer.cornerRadius = 33/2//done.layer.bounds.height / 2
        done.layer.borderWidth = 1
        done.layer.borderColor = done.backgroundColor?.cgColor
        
       cancel.layer.cornerRadius = 33/2//cancel.layer.bounds.height / 2
        cancel.layer.borderWidth = 1
        cancel.layer.borderColor = UIColor.white.cgColor //cancel.backgroundColor?.CGColor
        
    }
    
    
    //set selected date to text field
    func handleDatePicker(_ sender: UIDatePicker) {
        dateExpence.text = self.getStringDate(sender.date)
    }
    
    
    
    //++++++++++++++++++++++++++++++++++++
    //  Load Default Values from controller
    //++++++++++++++++++++++++++++++++++++
    func LoadDefaultValues(){
        amount.text = ""
        amount.becomeFirstResponder()
        
        setNowDate()
        
        let userDefaults:UserDefaults = UserDefaultsDataController().loadUserDefaults()
        
   
        reasonText = String(userDefaults.reason)
        
        causeOfSmoking.setTitle(reasonText, for: UIControlState())
        
        
    }
    
//MARK: Action
    @IBAction func cancelTouch(_ sender: AnyObject) {
          self.dismiss(animated: false, completion: nil)
    }
   
    @IBAction func finishTouch(_ sender: AnyObject) {
    if isNumeric(amount.text!){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        
        let dateString:String = dateExpence.text!
        let dateValue:Date?=dateFormatter.date(from: dateString)
        
        let amount = Double(self.amount.text!)!
        
        let cigRecord = CigaretteRecordManager()
        
        cigRecord.saveCigaretteRecordEntity( amount: amount, category: causeOfSmoking.currentTitle!, addedDate: dateValue!)
        
        
        if(myDelegate != nil){
            myDelegate!.dataReloadAfterSave()
        }
        
        self.dismiss(animated: false, completion: nil)
    }
    else{
        AlertError("Illegal value of amount")
        amount.text = ""
        }
    
    }

    func navigateToRoot(_ viewController: UIViewController, toViewController: TableLavels)
    {
        var nc = viewController.navigationController
        
        // If this is a normal view with NavigationController, then we just pop to root.
        if nc != nil
        {
            _ = nc?.popToRootViewController(animated: true)
        }
        
        // Most likely we are in Modal view, so we will need to search for a view with NavigationController.
        let vc = viewController.presentingViewController
        
        if nc == nil
        {
            nc = viewController.presentingViewController?.navigationController
        }
        
        if nc == nil
        {
            nc = viewController.parent?.navigationController
        }
        
        if vc is UINavigationController
        {
            nc = vc as? UINavigationController
        }
        
        if nc != nil
        {
            viewController.dismiss(animated: false, completion:nil)
            let fromViewController: LightMainSceneViewController = (nc?.viewControllers[0]) as! LightMainSceneViewController//.parentViewController!
            
            toViewController.myDelegate = fromViewController
            
            let fromView = fromViewController.view as UIView!
            let toView: UIView = toViewController.view as UIView!
            if let containerView = fromView?.superview {
                let initialFrame = fromView?.frame
                var offscreenRect = initialFrame
                offscreenRect?.origin.y += (initialFrame?.height)!
                toView.frame = offscreenRect!
                containerView.addSubview(toView)
                
                
                // Being explicit with the types NSTimeInterval and CGFloat are important
                // otherwise the swift compiler will complain
                let duration: TimeInterval = 0.4
                
                UIView.animate(withDuration: duration, animations: {
                    toView.frame = initialFrame!
                    }, completion: { finished in
                            nc!.viewControllers.append(toViewController)
                  
                        nc!.popToViewController(toViewController, animated: false)
                        
                        
                })
            }
        }
        
    }
    
    /*
    delegated function from TableLavels.swift
    received selected row value from TableLevels and set it to apropriate field
    */
    func myColumnDidSelected(_ controller: TableLavels, text: String, segueName: String) {
        
        if segueName == segueNames.segueCauseOfSmoking && !text.isEmpty {
            reasonText = text;
        }
        
      _ =  controller.navigationController?.popViewController(animated: true)
      
    }
    
}

protocol popOverControllerDelegate{
    func dataReloadAfterSave()
}
