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

class CmdVC: UIViewController {
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
        // 一定間隔で実行
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
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    
}
