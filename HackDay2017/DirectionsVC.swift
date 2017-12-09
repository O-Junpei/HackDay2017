//
//  DirectionsVC.swift
//  HackDay2017
//
//  Created by junpei ono on 2017/12/10.
//  Copyright © 2017年 junpei ono. All rights reserved.
//

import UIKit
import MapKit

class DirectionsVC: UIViewController, MKMapViewDelegate {
    
    private var viewWidth:CGFloat!
    private var viewHeight:CGFloat!
    private var statusBarHeight:CGFloat!
    private var navigationBarHeight:CGFloat!
    private var contentViewHeight:CGFloat!
    
    var shopName:String!
    var latitude:Double!
    var longitude:Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "道案内"
        
        //Viewの大きさを取得
        viewWidth = self.view.frame.size.width
        viewHeight = self.view.frame.size.height
        statusBarHeight = (self.navigationController?.navigationBar.frame.origin.y)!
        navigationBarHeight = (self.navigationController?.navigationBar.frame.size.height)!
        contentViewHeight = viewHeight - (statusBarHeight+navigationBarHeight)

        //現在地を取得したらマップを生成する
       setMaps()
    }
    
    func setMaps(){
        
        // mapViewを生成.
        let myMapView: MKMapView = MKMapView()
        myMapView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: contentViewHeight)
        
        // Delegateを設定.
        myMapView.delegate = self
        
        // 出発点の緯度、経度を設定.
        let myLatitude: CLLocationDegrees = 35.700525
        let myLongitude: CLLocationDegrees = 139.772508
        
        // 目的地の緯度、経度を設定.
        let requestLatitude: CLLocationDegrees = latitude
        let requestLongitude: CLLocationDegrees = longitude
        
        // 目的地の座標を指定.
        let requestCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(requestLatitude, requestLongitude)
        let fromCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLatitude, myLongitude)
        
        // 地図の中心を出発点と目的地の中間に設定する.
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake((myLatitude + requestLatitude)/2, (myLongitude + requestLongitude)/2)
        
        // mapViewに中心をセットする.
        myMapView.setCenter(center, animated: true)
        
        // 縮尺を指定.
        let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: center, span: mySpan)
        
        // regionをmapViewにセット.
        myMapView.region = myRegion
        
        // viewにmapViewを追加.
        self.view.addSubview(myMapView)
        
        // PlaceMarkを生成して出発点、目的地の座標をセット.
        let fromPlace: MKPlacemark = MKPlacemark(coordinate: fromCoordinate, addressDictionary: nil)
        let toPlace: MKPlacemark = MKPlacemark(coordinate: requestCoordinate, addressDictionary: nil)
        
        
        // Itemを生成してPlaceMarkをセット.
        let fromItem: MKMapItem = MKMapItem(placemark: fromPlace)
        let toItem: MKMapItem = MKMapItem(placemark: toPlace)
        
        // MKDirectionsRequestを生成.
        let myRequest: MKDirectionsRequest = MKDirectionsRequest()
        
        // 出発地のItemをセット.
        myRequest.source = fromItem
        
        // 目的地のItemをセット.
        myRequest.destination = toItem
        
        // 複数経路の検索を有効.
        myRequest.requestsAlternateRoutes = true
        
        // 移動手段を車に設定.
        myRequest.transportType = MKDirectionsTransportType.walking
        
        // MKDirectionsを生成してRequestをセット.
        let myDirections: MKDirections = MKDirections(request: myRequest)
        
        // 経路探索.
        myDirections.calculate { (response, error) in
            
            // NSErrorを受け取ったか、ルートがない場合.
            if error != nil || response!.routes.isEmpty {
                return
            }
            
            let route: MKRoute = response!.routes[0] as MKRoute
            print("目的地まで \(route.distance)km")
            print("所要時間 \(Int(route.expectedTravelTime/60))分")
            
            // mapViewにルートを描画.
            myMapView.add(route.polyline)
        }
        
        // ピンを生成.
        let fromPin: MKPointAnnotation = MKPointAnnotation()
        let toPin: MKPointAnnotation = MKPointAnnotation()
        
        // 座標をセット.
        fromPin.coordinate = fromCoordinate
        toPin.coordinate = requestCoordinate
        
        // titleをセット.
        fromPin.title = "出発地点"
        toPin.title = "目的地"
        
        // mapViewに追加.
        myMapView.addAnnotation(fromPin)
        myMapView.addAnnotation(toPin)
    }
    
    // ルートの表示設定.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let route: MKPolyline = overlay as! MKPolyline
        let routeRenderer: MKPolylineRenderer = MKPolylineRenderer(polyline: route)
        
        // ルートの線の太さ.
        routeRenderer.lineWidth = 3.0
        
        // ルートの線の色.
        routeRenderer.strokeColor = UIColor.red
        return routeRenderer
    }
}
