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

        //getLikeSpots()
        setGoogleMap()
    }
    
    
    func getLikeSpots() {
        Alamofire.request(UtilityLibrary.getAPIURL() + "/lilesplots").responseJSON{ response in
            
            switch response.result {
            case .success:
                
                let json:JSON = JSON(response.result.value ?? kill)
                self.likeSpots = json
                
            case .failure(let error):
                print(error)

            }
        }
    }

    func setGoogleMap() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
        let camera = GMSCameraPosition.camera(withLatitude: 35.700525, longitude: 139.772508, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 35.7040525, longitude: 139.775508)
        marker.title = "サンプル1"
        //marker.snippet = snippet
        marker.map = mapView
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: 35.6940525, longitude: 139.770508)
        marker2.title = "サンプル2"
        //marker.snippet = snippet
        marker2.map = mapView
    }
    
    
}
