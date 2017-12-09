//
//  LikeMapVC.swift
//  HackDay2017
//
//  Created by junpei ono on 2017/12/09.
//  Copyright © 2017年 junpei ono. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView
import GoogleMaps

class LikeMapVC: UIViewController {

    private var viewWidth:CGFloat!
    private var viewHeight:CGFloat!
    private var statusBarHeight:CGFloat!
    private var navigationBarHeight:CGFloat!
    private var contentViewHeight:CGFloat!
    
    var likeSpots:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        statusBarHeight = (self.navigationController?.navigationBar.frame.origin.y)!
        navigationBarHeight = (self.navigationController?.navigationBar.frame.size.height)!
        contentViewHeight = viewHeight - (statusBarHeight+navigationBarHeight)
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "ライクマップ"

        getLikeSpots()
        //
    }
    
    
    func getLikeSpots() {
        Alamofire.request("http://rainy-country.herokuapp.com/getnearlilespot?let=35.704&lang=139.771").responseJSON{ response in
            
            switch response.result {
            case .success:
                
                let json:JSON = JSON(response.result.value ?? kill)
                self.likeSpots = json["spots"]
                print(self.likeSpots)
                self.setGoogleMap()
            case .failure(let error):
                print(error)

            }
        }
    }

    func setGoogleMap() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
        let camera = GMSCameraPosition.camera(withLatitude: 35.700525, longitude: 139.772508, zoom: 13.5)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        for i in 0...self.likeSpots.count {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: self.likeSpots[i]["latitude"].doubleValue, longitude: self.likeSpots[i]["longitude"].doubleValue)
            marker.title = self.likeSpots[i]["shop_name"].stringValue
            marker.icon = UIImage(named: "rain")
            marker.map = mapView
            
        }
        

    }
    
    
}
