//
//  UserDefaultsManager.swift
//  HackDay2017
//
//  Created by junpei ono on 2017/12/09.
//  Copyright © 2017年 junpei ono. All rights reserved.
//

import UIKit


class UserDefaultsManager: NSObject {
    
    static let sharedInstance = UserDefaultsManager()
    var userDefaults:UserDefaults = UserDefaults.standard
    
    override init() {
        userDefaults.register(defaults: ["KEY_Wroom_IP": "123.456.789.123"])
        userDefaults.register(defaults: ["KEY_Wroom_Port": "12345"])
        userDefaults.register(defaults: ["KEY_API_URL": "http://rainy-country.herokuapp.com/"])
    }
}


class UtilityLibrary: NSObject {
    
    //WrromIPs
    class func getWroomIP()->String{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let userID:String = (appDelegate.userDefaultsManager?.userDefaults.string(forKey: "KEY_Wroom_IP"))!
        return userID
    }
    
    class func setWroomIP(wroomIP:String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.userDefaultsManager?.userDefaults.set(wroomIP, forKey: "KEY_Wroom_IP")
        return
    }
    
    //WrromPorts
    class func getWroomPort()->String{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let userName:String = (appDelegate.userDefaultsManager?.userDefaults.string(forKey: "KEY_Wroom_Port"))!
        return userName
    }
    
    class func setWroomPort(wroomPort:String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.userDefaultsManager?.userDefaults.set(wroomPort, forKey: "KEY_Wroom_Port")
        return
    }
    
    //API URLs
    class func getAPIURL()->String{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let userName:String = (appDelegate.userDefaultsManager?.userDefaults.string(forKey: "KEY_API_URL"))!
        return userName
    }
    
    class func setAPIUR(apiURL:String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.userDefaultsManager?.userDefaults.set(apiURL, forKey: "KEY_API_URL")
        return
    }
}
