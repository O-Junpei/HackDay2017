//
//  DestinationListVC.swift
//  HackDay2017
//
//  Created by junpei ono on 2017/12/10.
//  Copyright © 2017年 junpei ono. All rights reserved.
//

import UIKit

class DestinationListVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    private var viewWidth:CGFloat!
    private var viewHeight:CGFloat!
    private var statusBarHeight:CGFloat!
    private var navigationBarHeight:CGFloat!
    private var contentViewHeight:CGFloat!
    
    //テーブルビューインスタンス
    private var destinationListTableView: UITableView!
    private var destinationItems: NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "行き先リスト"
        
        //テーブルビューに表示する配列
        destinationItems = ["＠ホームカフェ", "お台場", "皇居", "秋月電子", "とらのあな", "メロンブックス"]
        
        //Viewの大きさを取得
        viewWidth = self.view.frame.size.width
        viewHeight = self.view.frame.size.height
        statusBarHeight = (self.navigationController?.navigationBar.frame.origin.y)!
        navigationBarHeight = (self.navigationController?.navigationBar.frame.size.height)!
        contentViewHeight = viewHeight - (statusBarHeight+navigationBarHeight)
        
        //テーブルビューの初期化
        destinationListTableView = UITableView()
        destinationListTableView.delegate = self
        destinationListTableView.dataSource = self
        destinationListTableView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: contentViewHeight)
        destinationListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(destinationListTableView)
    }

    //MARK: テーブルビューのセルの数を設定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //テーブルビューのセルの数はmyItems配列の数とした
        return self.destinationItems.count
    }
    
    //MARK: テーブルビューのセルの中身を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //myItems配列の中身をテキストにして登録した
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = self.destinationItems[indexPath.row] as? String
        return cell
    }
    
    //Mark: テーブルビューのセルが押されたら呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            //＠ホームカフェ
            let directionListView: DirectionsVC = DirectionsVC()
            directionListView.latitude = 123456
            directionListView.longitude = 123456
            let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(directionListView, animated: true)
        case 1:
            //お台場
            let directionListView: DirectionsVC = DirectionsVC()
            let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(directionListView, animated: true)
        case 2:
            //皇居
            print("aaa")
        default:
            print("aaa")
        }
        print("\(indexPath.row)番のセルを選択しました！ ")
    }
}
