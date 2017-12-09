//
//  ViewController.swift
//  HackDay2017
//
//  Created by junpei ono on 2017/12/09.
//  Copyright © 2017年 junpei ono. All rights reserved.
//

import UIKit
import SwiftSocket
import Alamofire
import SwiftyJSON
class ViewController: UIViewController {
    
    private var viewWidth:CGFloat!
    private var viewHeight:CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        
        //getMapApi()
        
        sendUDP()
    }

    func sendUDP(){
        
        
        let client = UDPClient(address: "10.11.98.176", port: 12345)
        let data: Data = "kabigon-daisuiki".data(using: .utf8)!
        let result = client.send(data: data)
        print(result)
        //let aaa = client.recv(3)
        //print(aaa)
    }
    
    
    
    func showWebView() {
        //WebView
        let webview = UIWebView()
        webview.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        self.view.addSubview(webview)
        
        // URLを設定.
        let url: URL = URL(string: "http://swiswiswift.com/")!
        let request: NSURLRequest = NSURLRequest(url: url)
        webview.loadRequest(request as URLRequest)
        self.view.addSubview(webview)
    }
    
    
    func getMapApi() {
        //お天気APIから東京の天気を取得する
        let url:String = "https://maps.googleapis.com/maps/api/directions/json?origin=75+9th+Ave+New+York,+NY&destination=MetLife+Stadium+1+MetLife+Stadium+Dr+East+Rutherford,+NJ+07073&key=AIzaSyDM1iVF73DzB5cRG5C0xHrIMUIKepofwow"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON{ response in
            
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
