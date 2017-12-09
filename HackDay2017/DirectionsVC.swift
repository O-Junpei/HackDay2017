//
//  DirectionsVC.swift
//  HackDay2017
//
//  Created by junpei ono on 2017/12/10.
//  Copyright © 2017年 junpei ono. All rights reserved.
//

import UIKit
import GoogleMaps

class DirectionsVC: UIViewController {
    
    var shopName:String!
    var latitude:Double!
    var longitude:Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "道案内"

        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = shopName
        //marker.snippet = snippet
        marker.map = mapView
    }

}
