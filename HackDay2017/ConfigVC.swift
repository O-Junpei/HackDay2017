//
//  ConfigVC.swift
//  HackDay2017
//
//  Created by junpei ono on 2017/12/09.
//  Copyright © 2017年 junpei ono. All rights reserved.
//

import UIKit
import CoreLocation
import SCLAlertView
import SwiftSocket
import Alamofire
import SwiftyJSON

class ConfigVC: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    private var viewWidth:CGFloat!
    private var viewHeight:CGFloat!
    private var statusBarHeight:CGFloat!
    private var navigationBarHeight:CGFloat!
    private var contentViewHeight:CGFloat!
    
    //テーブルビューインスタンス
    private var configTableView: UITableView!
    private var configItems: NSArray = []
    
    //ロケーション
    var locationManager: CLLocationManager!
    var latitude = 35.700525
    var longitude = 139.772508

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "設定"

        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        statusBarHeight = (self.navigationController?.navigationBar.frame.origin.y)!
        navigationBarHeight = (self.navigationController?.navigationBar.frame.size.height)!
        contentViewHeight = viewHeight - (statusBarHeight+navigationBarHeight)

        //テーブルビューに表示する配列
        configItems = ["wroomIP変更:", "wroomPort変更:","UDP強制送信(deprecate)","APIURL変更:", "位置情報取得","UDPでLED点灯命令","いいねAPIを押す","トランザクションAPIを押す","ランダムピカピアカ(下)","ピカピカ上と下","前", "右斜め前", "左斜め前", "右斜め後ろ","左斜め後ろ","後ろ","全部消す"]
        
        //テーブルビューの初期化
        configTableView = UITableView()
        configTableView.delegate = self
        configTableView.dataSource = self
        configTableView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: contentViewHeight)
        configTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(configTableView)
        
        //ロケーション
        locationManager = CLLocationManager() // インスタンスの生成
        locationManager.delegate = self  // CLLocationManagerDelegateプロトコルを実装するクラスを指定する
        locationManager.startUpdatingLocation()
        
    }
    
    //MARK: テーブルビューのセルの数を設定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //テーブルビューのセルの数はmyItems配列の数とした
        return self.configItems.count
    }
    
    //MARK: テーブルビューのセルの中身を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //myItems配列の中身をテキストにして登録した
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = (self.configItems[indexPath.row] as? String)! + UtilityLibrary.getWroomIP()
        case 1:
            cell.textLabel?.text = (self.configItems[indexPath.row] as? String)! + UtilityLibrary.getWroomPort()
        case 2:
            cell.textLabel?.text = (self.configItems[indexPath.row] as? String)!
        case 3:
            //APIのURL変更
            cell.textLabel?.text = (self.configItems[indexPath.row] as? String)! + UtilityLibrary.getAPIURL()
        case 4:
            //現在地取得
            cell.textLabel?.text = (self.configItems[indexPath.row] as? String)!
        case 5:
            //現在地取得
            cell.textLabel?.text = (self.configItems[indexPath.row] as? String)!
        case 6:
            //いいねAPIをとりあえず押す
            cell.textLabel?.text = (self.configItems[indexPath.row] as? String)!
        case 7:
            //作成APIをとりあえず押す
            cell.textLabel?.text = (self.configItems[indexPath.row] as? String)!
        case 8:
            //ランダムに傘の色を変更する(下)
            cell.textLabel?.text = (self.configItems[indexPath.row] as? String)!
        case 9:
            //下と上のLEDの変更k
            cell.textLabel?.text = (self.configItems[indexPath.row] as? String)!
        default:
            cell.textLabel?.text = (self.configItems[indexPath.row] as? String)!

        }
        return cell
    }
    
    //Mark: テーブルビューのセルが押されたら呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            //WroomのIPの変更
            let alert = SCLAlertView()
            let txt = alert.addTextField(UtilityLibrary.getWroomIP())
            alert.addButton("変更") {
                if let newIP = txt.text{
                    UtilityLibrary.setWroomIP(wroomIP: newIP)
                    self.configTableView.reloadData()
                }else{
                    SCLAlertView().showWarning("Error", subTitle: "起きてはいけないエラー")
                }
            }
            alert.showEdit("WroomのIP変更", subTitle: "IPを打ち込んでね！")
            
        case 1:
            //WroomのPortの変更
            let alert = SCLAlertView()
            let txt = alert.addTextField(UtilityLibrary.getWroomPort())
            alert.addButton("変更") {
                if let newPort = txt.text{
                    UtilityLibrary.setWroomPort(wroomPort: newPort)
                    self.configTableView.reloadData()
                }else{
                    SCLAlertView().showWarning("Error", subTitle: "起きてはいけないエラー")
                }
            }
            alert.showEdit("WroomのIP変更", subTitle: "IPを打ち込んでね！")
        
        case 2:
            //WroomへUDP強制送信
            let alert = SCLAlertView()
            let txt = alert.addTextField("ここに送る文字列")
            alert.addButton("送信") {
                if let sendText = txt.text{

                    let client = UDPClient(address: UtilityLibrary.getWroomIP(), port: Int32(UtilityLibrary.getWroomPort())!)
                    let data: Data = sendText.data(using: .utf8)!
                    let result = client.send(data: data)
                    print(result)
                }else{
                    SCLAlertView().showWarning("Error", subTitle: "起きてはいけないエラー")
                }
            }
            alert.showEdit("WroomへUDP送信", subTitle: "送る文字列を打ち込んでね！")
        case 3:
            //APIのURLの変更
            let alert = SCLAlertView()
            let txt = alert.addTextField(UtilityLibrary.getAPIURL())
            alert.addButton("APIURL変更") {
                if let newAPIURL = txt.text{
                    UtilityLibrary.setAPIUR(apiURL: newAPIURL)
                    self.configTableView.reloadData()
                }else{
                    SCLAlertView().showWarning("Error", subTitle: "起きてはいけないエラー")
                }
            }
            alert.showEdit("WroomのIP変更", subTitle: "IPを打ち込んでね！")
        
        case 4:
            //現在の位置情報取得
            locationManager.requestLocation() // 一度きりの取得
            SCLAlertView().showInfo("位置情報取得", subTitle: "緯度:\(latitude) \n 経度:\(longitude)")
            
        case 5:
            //点灯命令
            let client = UDPClient(address: UtilityLibrary.getWroomIP(), port: Int32(UtilityLibrary.getWroomPort())!)
            var json:Dictionary<String, Any> = ["cmd": 0]
            let led = [0xff0000,0x00ff00,0xffff00,0x000000,0x00ff00,0xffff00,0xff0000,0x000000,0x00ff00,0xffff00,0xff0000,0x000000]
            json["led"] = led
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                let jsonStr = String(bytes: jsonData, encoding: .utf8)!
                print(jsonStr)
                
                let data: Data = jsonStr.data(using: .utf8)!
                let result = client.send(data: data)
                print(result)
            } catch let error {
                print(error)
            }
            
        case 6:
            //いいねAPI
            let parameters: Parameters = [
                "lat": Float(latitude),
                "lang": Float(longitude)
            ]
            print(parameters)

            Alamofire.request(UtilityLibrary.getAPIURL() + "likespot/", method: .post, parameters: parameters,encoding: JSONEncoding.default).responseJSON{ response in
                
                switch response.result {
                case .success:
                    let json:JSON = JSON(response.result.value ?? kill)
                    print(json)
                case .failure(let error):
                    print(error)
                }
            }
            
        case 7:
            //makeAPI
            let parameters: Parameters = [
                "index": Int(arc4random_uniform(9999)),
                "lat": Float(latitude),
                "lang": Float(longitude),
                "to_id":"123.456.788",
                "from_id":"123.456.788",
                "amount":Int(arc4random_uniform(234))
            ]
            print(parameters)
            
            
            Alamofire.request(UtilityLibrary.getAPIURL() + "make/", method: .post, parameters: parameters,encoding: JSONEncoding.default).responseJSON{ response in
                
                switch response.result {
                case .success:
                    let json:JSON = JSON(response.result.value ?? kill)
                    print(json)
                case .failure(let error):
                    print(error)
                }
            }
        case 8:
            //ランダムに道をピカピカする　下
            //点灯命令
            let client = UDPClient(address: UtilityLibrary.getWroomIP(), port: Int32(UtilityLibrary.getWroomPort())!)
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
            
        case 9:
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
            
        case 10:
            //前
            let client = UDPClient(address: UtilityLibrary.getWroomIP(), port: Int32(UtilityLibrary.getWroomPort())!)
            var json:Dictionary<String, Any> = ["cmd": 2]
            let led = [0x00ff00,0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x0000,0x0000ff]
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
                let led2:[Int] = [0x000000,0x000000,0x000000,0x000000,0x000000,0xff0000]
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

            
        case 11:
            //右斜め前
            let client = UDPClient(address: UtilityLibrary.getWroomIP(), port: Int32(UtilityLibrary.getWroomPort())!)
            var json:Dictionary<String, Any> = ["cmd": 2]
            let led = [0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x00ff00,0x00ff,0x000000]
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
                let led2:[Int] = [0x000000,0x000000,0x000000,0x000000,0xff0000,0x000000]
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
            
        case 12:
            //左斜め前
            let client = UDPClient(address: UtilityLibrary.getWroomIP(), port: Int32(UtilityLibrary.getWroomPort())!)
            var json:Dictionary<String, Any> = ["cmd": 2]
            let led = [0x000000,0xff0000,0x00ff00,0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x0000,0x000000]
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
                let led2:[Int] = [0x0000ff,0x000000,0x000000,0x000000,0x000000,0x000000]
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
        case 13:
            //右斜め後ろ
            let client = UDPClient(address: UtilityLibrary.getWroomIP(), port: Int32(UtilityLibrary.getWroomPort())!)
            var json:Dictionary<String, Any> = ["cmd": 2]
            let led = [0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x000000,0x00ff00,0xff0000,0x000000,0x0000,0x000000]
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
                let led2:[Int] = [0x000000,0x000000,0x000000,0x0000ff,0x000000,0x000000]
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
        case 14:
            //左斜め後ろ
            let client = UDPClient(address: UtilityLibrary.getWroomIP(), port: Int32(UtilityLibrary.getWroomPort())!)
            var json:Dictionary<String, Any> = ["cmd": 2]
            let led = [0x000000,0x000000,0x000000,0x00ff00,0xff0000,0x000000,0x000000,0x000000,0x000000,0x000000,0x0000,0x000000]
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
                let led2:[Int] = [0x000000,0x0000ff,0x000000,0x000000,0x000000,0x000000]
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
            
        case 15:
            //後ろ
            let client = UDPClient(address: UtilityLibrary.getWroomIP(), port: Int32(UtilityLibrary.getWroomPort())!)
            var json:Dictionary<String, Any> = ["cmd": 2]
            let led = [0x000000,0x000000,0x000000,0x000000,0x000000,0xff0000,0x00ff00,0x000000,0x000000,0x000000,0x0000,0x000000]
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
                let led2:[Int] = [0x000000,0x000000,0x0000ff,0x000000,0x000000,0x000000]
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
        case 16:
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
            
        case 17:
            //Lineモード
            print("adad")
            
        default:
            SCLAlertView().showWarning("Error", subTitle: "起きてはいけないエラー")
        }
    }
}


extension ConfigVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
             // 起動中のみの取得許可を求める
            locationManager.requestWhenInUseAuthorization() // 起動中のみの取得許可を求める

            break
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            break
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            break
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            break
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            print("緯度:\(location.coordinate.latitude) 経度:\(location.coordinate.longitude) 取得時刻:\(location.timestamp)")
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    // requestLocation()を使用する場合、失敗した際のDelegateメソッドの実装が必須
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗しました")
    }
}
