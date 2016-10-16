//
//  UserDefaultsDataController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 9/20/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//

import Foundation


class UserDefaults{
    
    class func newInstance() -> UserDefaults {
        return UserDefaults();
    }
    
    var levelAsNeeded = 0
    var levelOfEnjoyment = 0
    var dailyGoal:Int = 0 //month budget
    var todaySmoked = 0.0 //today spend
    var dateLastCig: Date! //last date spend
    var reason: String!//category
    var minimalModeOn: Bool!
    var averageCostOfOnePack = 0.0//monthly spend
    var averageCostOfOneCigarett = 0.0
    var amountOfCigarettsInOnePack = 0
    var showQuestion1: Bool!
    var coreDataReasonsEntityInited: Bool!
    
} 

class UserDefaultsDataController{
    
    class func newInstance() -> UserDefaultsDataController {
        return UserDefaultsDataController();
    }
  
    //++++++++++++++++++++++++++++++++++++
    //  will save user defaults
    //++++++++++++++++++++++++++++++++++++
      func saveUserDefaults(_ userDefaults: UserDefaults) {
        
        
        let defaults = Foundation.UserDefaults.standard
        
  //      userDefaults.levelAsNeeded = 10
        
        defaults.set(userDefaults.levelAsNeeded, forKey: "levelAsNeeded")
        
        defaults.set(userDefaults.levelOfEnjoyment, forKey: "levelOfEnjoyment")
    
        defaults.set(userDefaults.dailyGoal, forKey: "dailyGoal")
    
        defaults.set(userDefaults.averageCostOfOnePack, forKey: "averageCostOfOnePack")
        
        defaults.set(userDefaults.averageCostOfOneCigarett, forKey: "averageCostOfOneCigarett")
 
        
        defaults.set(userDefaults.amountOfCigarettsInOnePack, forKey: "amountOfCigarettsInOnePack")
 
        defaults.setValue(userDefaults.reason, forKey: "reason")
        
        defaults.setValue(Bool(userDefaults.minimalModeOn), forKey: "minimalModeOn")
        
        defaults.set(Bool(userDefaults.showQuestion1), forKey: "showQuestion1")
        defaults.set(Bool(userDefaults.coreDataReasonsEntityInited), forKey: "coreDataReasonsEntityInited")
       
       // defaults.synchronize()
    }
    
    @objc  func saveLastAddedCig(_ lastDateCig: Date, todaySmoked: Double) {
       
        if newDateIsToday(lastDateCig){

            let defaults = Foundation.UserDefaults.standard
        
            defaults.set(todaySmoked, forKey: "todaySmoked")

            defaults.set(lastDateCig, forKey: "dateLastCig")
         //   defaults.synchronize()
        }
    }
   
    @objc  func saveLastAddedMonthExpence(_ lastDateCig: Date, amount: Double) {
        let defaults = Foundation.UserDefaults.standard
        if newDateIsToday(lastDateCig){
            defaults.set(amount, forKey: "averageCostOfOnePack")
            defaults.set(lastDateCig, forKey: "dateLastCig")
        }
        else
        {
            let userDefaults:UserDefaults = loadUserDefaults()
            
            if let lastCig = userDefaults.dateLastCig{
                let calcRet = calculateLastCigaretTime(lastCig)
                
                if calcRet.bLastRecordWasThisMonth{
                    defaults.set(amount, forKey: "averageCostOfOnePack")
                 //   defaults.set(lastDateCig, forKey: "dateLastCig")
                }
                
            }
            else{
                let calcRet = calculateLastCigaretTime(lastDateCig)
                
                if calcRet.bLastRecordWasThisMonth{
                    defaults.set(amount, forKey: "averageCostOfOnePack")
                    defaults.set(lastDateCig, forKey: "dateLastCig")
                }
            }
            
        }
        
    }
    
    func newDateIsToday(_ newDate: Date) -> Bool
    {
        let calendar = Calendar.current
        return calendar.isDateInToday(newDate)
    }
    
    func newDateIsLatest(_ newDate: Date) -> Bool
    {
        //Get Current Date/Time
        let currentDateTime = Date()

        var ret = false;
        
        let userDefaults:UserDefaults = UserDefaultsDataController().loadUserDefaults()
        
        if let lastDateOfCig = userDefaults.dateLastCig{
            if newDate >= lastDateOfCig && newDate <= currentDateTime {
                ret = true
            }
        }
        else
        {
            if newDate <= currentDateTime {
                ret = true
            }
        }
        
        return ret;
    }
    
    //++++++++++++++++++++++++++++++++++++
    //  load user defaults into object
    //++++++++++++++++++++++++++++++++++++
      func loadUserDefaults() -> UserDefaults{
        
        let userDefaults = UserDefaults()
        
        let defaults = Foundation.UserDefaults.standard
        
        if (defaults.object(forKey: "levelAsNeeded") == nil) {
           //then it loads for the first time
            //init defaults values for start up
            userDefaults.dailyGoal = 10000//budget
            userDefaults.averageCostOfOnePack = 10
            userDefaults.amountOfCigarettsInOnePack = 20
            userDefaults.averageCostOfOneCigarett = 10 / 20
            userDefaults.levelAsNeeded = 1
            userDefaults.levelOfEnjoyment = 1
            userDefaults.todaySmoked = 0
            userDefaults.reason = defaultReason
            userDefaults.minimalModeOn = false
            userDefaults.showQuestion1 = true
            userDefaults.coreDataReasonsEntityInited = false
            saveUserDefaults(userDefaults)
        }
        else{
            var needSaveFlag:Bool = false
        userDefaults.levelAsNeeded = defaults.integer(forKey: "levelAsNeeded")
        
        userDefaults.levelOfEnjoyment = defaults.integer(forKey: "levelOfEnjoyment")
        userDefaults.dailyGoal = defaults.integer(forKey: "dailyGoal")
        userDefaults.averageCostOfOnePack = defaults.double(forKey: "averageCostOfOnePack")
       
            userDefaults.amountOfCigarettsInOnePack = defaults.integer(forKey: "amountOfCigarettsInOnePack")
            userDefaults.averageCostOfOneCigarett = defaults.double(forKey: "averageCostOfOneCigarett")
                
            userDefaults.todaySmoked = defaults.double(forKey: "todaySmoked")
            
            if let d:Date = defaults.object(forKey: "dateLastCig") as? Date{
                userDefaults.dateLastCig = d
            }
            
            if let reason = defaults.object(forKey: "reason") as? String{
                userDefaults.reason = reason
            }
            else
            {
                userDefaults.reason = defaultReason
                needSaveFlag = true
            }
            if let minimalModeOn = defaults.object(forKey: "minimalModeOn") as? Bool{
                userDefaults.minimalModeOn = minimalModeOn
            }
            else
            {
                userDefaults.minimalModeOn = false
                needSaveFlag = true
            }
            if let showQuestion1 = defaults.object(forKey: "showQuestion1") as? Bool{
                userDefaults.showQuestion1 = showQuestion1
            }
            else
            {
                userDefaults.showQuestion1 = true
                needSaveFlag = true
               
            }
            if let coreDataReasonsEntityInited = defaults.object(forKey: "coreDataReasonsEntityInited") as? Bool{
                userDefaults.coreDataReasonsEntityInited = coreDataReasonsEntityInited
            }
            else
            {
                userDefaults.coreDataReasonsEntityInited = false
                needSaveFlag = true
                
            }
            
            
            if (needSaveFlag)
            {
                 saveUserDefaults(userDefaults)
            }
        }
        return userDefaults
    }
    
}
