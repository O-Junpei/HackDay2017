//
//  CmdVC.swift
//  HackDay2017
//
//  Created by junpei ono on 2017/12/10.
//  Copyright © 2017年 junpei ono. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSocket

class CmdVC: UIViewController {
    
    var timer: Timer!
    
    var label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        deleateAll()
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
        // 一定間隔で実行
        
        label = UILabel()
        label.text = "null"
        label.frame =  CGRect(x: 0, y: 100, width: self.view.frame.width, height: 50)
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer.invalidate()
    }
    
    @objc func update(tm: Timer) {
        // do something
        print("---------")
        get()
    }
    
    func get() {
        
        Alamofire.request("http://" + UtilityLibrary.getWroomIP() + "/res", method: .get, encoding: JSONEncoding.default).responseJSON{ response in
            
            switch response.result {
            case .success:
                
                let json:JSON = JSON(response.result.value ?? kill)
                print(json)
                self.label.text = json["cmd"].stringValue 
                if json["cmd"].stringValue == "iine"{
                    self.pikapika()
                }else{
                    self.deleateAll()
                }
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func deleateAll(){
        //全消し
        let client = UDPClient(address: UtilityLibrary.getWroomIP(), port: Int32(UtilityLibrary.getWroomPort())!)
        var json:Dictionary<String, Any> = ["cmd": 2]
        let led = [0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x0000,0x000000]
        json["led"] = led
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
            let data: Data = jsonStr.data(using: .utf8)!
            let result = client.send(data: data)
            print(result)
        } catch let error {
            print(error)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // 1秒後に実行したい処理
            //下ピカピカ
            var json2:Dictionary<String, Any> = ["cmd": 1]
            let led2:[Int] = [0x000000,0x000000,0x000000,0x000000,0x000000,0x000000]
            json2["led"] = led2
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json2, options: [])
                let jsonStr = String(bytes: jsonData, encoding: .utf8)!
                let data: Data = jsonStr.data(using: .utf8)!
                let result = client.send(data: data)
                print(result)
            } catch let error {
                print(error)
            }
        }
        
    }
    
    func pikapika(){
        
        
        //上下ピカピカ
        let client = UDPClient(address: UtilityLibrary.getWroomIP(), port: Int32(UtilityLibrary.getWroomPort())!)
        //上ピカピカ
        var json:Dictionary<String, Any> = ["cmd": 2]
        var led:[Int] = []
        
        for i in 0...11 {
            //
            print(i)
            let red:Int = Int(arc4random_uniform(255))
            let blue:Int = Int(arc4random_uniform(255))
            let yellow:Int = Int(arc4random_uniform(255))
            print(String(red, radix: 16))
            let colorStr:String = String(red, radix: 16) + String(blue, radix: 16) + String(yellow, radix: 16)
            print(colorStr)
            let color:Int = Int(colorStr, radix: 16) ?? 0
            led.append(color)
        }
        json["led"] = led
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
            print(jsonStr)  // 生成されたJSON文字列 => {"Name":"Taro"}
            
            let data: Data = jsonStr.data(using: .utf8)!
            let result = client.send(data: data)
            print(result)
        } catch let error {
            print(error)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // 0.5秒後に実行したい処理
            
            //下ピカピカ
            var json2:Dictionary<String, Any> = ["cmd": 1]
            var led2:[Int] = []
            
            for i in 0...5 {
                //
                print(i)
                let red:Int = Int(arc4random_uniform(255))
                let blue:Int = Int(arc4random_uniform(255))
                let yellow:Int = Int(arc4random_uniform(255))
                print(String(red, radix: 16))
                let colorStr:String = String(red, radix: 16) + String(blue, radix: 16) + String(yellow, radix: 16)
                print(colorStr)
                let color:Int = Int(colorStr, radix: 16) ?? 0
                led2.append(color)
            }
            json2["led"] = led2
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json2, options: [])
                let jsonStr = String(bytes: jsonData, encoding: .utf8)!
                print(jsonStr)  // 生成されたJSON文字列 => {"Name":"Taro"}
                
                let data: Data = jsonStr.data(using: .utf8)!
                let result = client.send(data: data)
                print(result)
            } catch let error {
                print(error)
            }
        }

    }
}
