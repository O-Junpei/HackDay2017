//
//  LikeMapVC.swift
//  HackDay2017
//
//  Created by junpei ono on 2017/12/09.
//  Copyright © 2017年 junpei ono. All rights reserved.
//

import UIKit
import SCLAlertView

class LikeMapVC: UIViewController {

    private var viewWidth:CGFloat!
    private var viewHeight:CGFloat!
    private var statusBarHeight:CGFloat!
    private var navigationBarHeight:CGFloat!
    private var contentViewHeight:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        statusBarHeight = (self.navigationController?.navigationBar.frame.origin.y)!
        navigationBarHeight = (self.navigationController?.navigationBar.frame.size.height)!
        contentViewHeight = viewHeight - (statusBarHeight+navigationBarHeight)
        
        self.view.backgroundColor = UIColor.red
        self.navigationItem.title = "ライクマップ"

        //WebView
        let webview = UIWebView()
        webview.frame = CGRect(x: 0, y: 0, width: viewWidth, height: contentViewHeight)
        self.view.addSubview(webview)

        // URLを設定.
        let url: URL = URL(string: "http://swiswiswift.com/")!
        let request: NSURLRequest = NSURLRequest(url: url)
        webview.loadRequest(request as URLRequest)
    }
}
