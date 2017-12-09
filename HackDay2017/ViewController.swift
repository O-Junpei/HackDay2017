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
        
        
    }

    func sendUDP(){
        
        
        let client = UDPClient(address: "192.168.43.76", port: 12345)
        let data: Data = "kabigon-daisuiki".data(using: .utf8)!
        let result = client.send(data: data)
        print(result)
    }
    
    
    
    func showWebView() {
        //WebView
        let webview = UIWebView()
        webview.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        self.view.addSubview(webview)
        
        // URLを設定.
        let url: URL = URL(string: "http://swiswiswift.com/")!
        
        // リエストを発行する.
        let request: NSURLRequest = NSURLRequest(url: url)
        
        // リクエストを発行する.
        webview.loadRequest(request as URLRequest)
        
        // Viewに追加する
        self.view.addSubview(webview)
    }
}
