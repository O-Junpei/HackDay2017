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

class ViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    private var viewWidth:CGFloat!
    private var viewHeight:CGFloat!
    private var statusBarHeight:CGFloat!
    private var navigationBarHeight:CGFloat!
    private var contentViewHeight:CGFloat!
    
    private var contentsTableView: UITableView!
    private var contentsItems: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        statusBarHeight = (self.navigationController?.navigationBar.frame.origin.y)!
        navigationBarHeight = (self.navigationController?.navigationBar.frame.size.height)!
        contentViewHeight = viewHeight - (statusBarHeight+navigationBarHeight)
        
        
        //バーの右側に設置するボタンの作成
        let rightNavBtn = UIBarButtonItem()
        rightNavBtn.image = UIImage(named:"config")!
        rightNavBtn.action = #selector(postBarBtnClicked(sender:))
        rightNavBtn.target = self
        self.navigationItem.rightBarButtonItem = rightNavBtn
        
        //テーブルビューに表示する配列
        contentsItems = ["魔女の道案内:", "いいね地図"]
        
        //道案内
        let client = UDPClient(address: UtilityLibrary.getWroomIP(), port: 12345)
        
        var json:Dictionary<String, Any> = ["cmd": 1]
        let led = [1,2,3]
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
        
        //テーブルビューの初期化
        contentsTableView = UITableView()
        contentsTableView.delegate = self
        contentsTableView.dataSource = self
        contentsTableView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: contentViewHeight)
        contentsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(contentsTableView)
        
        
        //いいねされた場所の地図
        
        
    }

    //右側のボタンが押されたら呼ばれる
    @objc func postBarBtnClicked(sender: UIButton){
        
        //設定へ
        let configView: ConfigVC = ConfigVC()
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(configView, animated: true)
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
    
    
    //MARK: テーブルビューのセルの数を設定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //テーブルビューのセルの数はmyItems配列の数とした
        return self.contentsItems.count
    }
    
    //MARK: テーブルビューのセルの中身を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //myItems配列の中身をテキストにして登録した
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = (self.contentsItems[indexPath.row] as? String)!
        return cell
    }
    
    //Mark: テーブルビューのセルが押されたら呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            //設定へ
            let configView: ConfigVC = ConfigVC()
            let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(configView, animated: true)
        default:
            //設定へ
            let likeMapView: LikeMapVC = LikeMapVC()
            let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(likeMapView, animated: true)
        }
    }
}
