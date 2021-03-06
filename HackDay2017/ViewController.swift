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
        contentsItems = ["魔女の道案内", "いいね地図", "雨の国","コントロール画面"]
        
        //テーブルビューの初期化
        contentsTableView = UITableView()
        contentsTableView.delegate = self
        contentsTableView.dataSource = self
        contentsTableView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: contentViewHeight)
        contentsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(contentsTableView)
        
        //強制的にAPIのURLを変更する
        UtilityLibrary.setAPIUR(apiURL: "http://rainy-country.herokuapp.com/")
        
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
        let url:String = "http://192.168.128.197/res"
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
            //道案内へ
            let directionListView: DestinationListVC = DestinationListVC()
            let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(directionListView, animated: true)
            
        case 1:
            //良いね地図へ
            let likeMapView: LikeMapVC = LikeMapVC()
            let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(likeMapView, animated: true)
        case 2:
            //雨の国へ
            let rainView: RainVisualVC = RainVisualVC()
            let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(rainView, animated: true)
        default:
            //コントロール画面へ
            let commandView: CmdVC = CmdVC()
            let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(commandView, animated: true)
        }
    }
}
