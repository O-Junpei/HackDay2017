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
        //UserInfo
        userDefaults.register(defaults: ["KEY_login": false])
        userDefaults.register(defaults: ["KEY_MyUserID": ""])
        userDefaults.register(defaults: ["KEY_MyUserName": ""])
        userDefaults.register(defaults: ["KEY_MyUserEmail": ""])
        userDefaults.register(defaults: ["KEY_MyUserIconUrl": ""])
        userDefaults.register(defaults: ["KEY_MyUserProfile": ""])
        
        //Tokens
        userDefaults.register(defaults: ["KEY_MyAccessToken": ""])
        userDefaults.register(defaults: ["KEY_MyClientToken": ""])
        userDefaults.register(defaults: ["KEY_MyExpiry": ""])
        userDefaults.register(defaults: ["KEY_MyUniqID": ""])
        
        //Supports
        userDefaults.register(defaults: ["KEY_SUPPORT_Field": false])
        userDefaults.register(defaults: ["KEY_SUPPORT_TimeLine": false])
        userDefaults.register(defaults: ["KEY_SUPPORT_Post": false])
        userDefaults.register(defaults: ["KEY_SUPPORT_PostDetail": false])
        userDefaults.register(defaults: ["KEY_SUPPORT_Zoo": false])
    }
    
    func doLogin(userID:String, userName:String, email:String, iconUrl:String, profile:String, accessToken:String, clientToken:String, expiry:String, uniqID:String) {
        userDefaults.set(true, forKey: "KEY_login")
        userDefaults.set(userID, forKey: "KEY_MyUserID")
        userDefaults.set(userName, forKey: "KEY_MyUserName")
        userDefaults.set(email, forKey: "KEY_MyUserEmail")
        userDefaults.set(iconUrl, forKey: "KEY_MyUserIconUrl")
        userDefaults.set(profile, forKey: "KEY_MyUserProfile")
        
        userDefaults.set(accessToken, forKey: "KEY_MyAccessToken")
        userDefaults.set(clientToken, forKey: "KEY_MyClientToken")
        userDefaults.set(accessToken, forKey: "KEY_MyExpiry")
        userDefaults.set(uniqID, forKey: "KEY_MyUniqID")
    }
    
    func doLogout(){
        
        userDefaults.set(false, forKey: "KEY_login")
        userDefaults.set("", forKey: "KEY_MyUserID")
        userDefaults.set("", forKey: "KEY_MyUserName")
        userDefaults.set("", forKey: "KEY_MyUserEmail")
        userDefaults.set("", forKey: "KEY_MyUserIconUrl")
        userDefaults.set("", forKey: "KEY_MyUserProfile")
        
        userDefaults.set("", forKey: "KEY_MyAccessToken")
        userDefaults.set("", forKey: "KEY_MyClientToken")
        userDefaults.set("", forKey: "KEY_MyExpiry")
        userDefaults.set("", forKey: "KEY_MyUniqID")
        
        userDefaults.set(false, forKey: "KEY_SUPPORT_Field")
        userDefaults.set(false, forKey: "KEY_SUPPORT_TimeLine")
        userDefaults.set(false, forKey: "KEY_SUPPORT_Post")
        userDefaults.set(false, forKey: "KEY_SUPPORT_PostDetail")
        userDefaults.set(false, forKey: "KEY_SUPPORT_Zoo")
        userDefaults.set(false, forKey: "KEY_SUPPORT_PostDetail")
    }
}

