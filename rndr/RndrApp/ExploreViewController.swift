////
////  ExploreViewController.swift
////  RndrApp
////
////  Created by William Smith on 11/12/16.
////  Copyright © 2016 William Smith. All rights reserved.
////
//
//import UIKit
//import GoogleMaps
//
//class ExploreViewController: UIViewController, CLLocationManagerDelegate {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        var dataManager = DataManager()
//        dataManager.retieveNearbyPosts()
//        
//        // get current location from user
//        let locManager = CLLocationManager()
//        locManager.delegate = self
//        locManager.requestAlwaysAuthorization()
//        
//        var currentLocation : CLLocation!
//        
//        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized) {
//            
//            currentLocation = locManager.location
//        }
//        else {
//            currentLocation = CLLocation(latitude: 37.868485, longitude: -122.26385)
//        }
//        
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 15.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        mapView.isMyLocationEnabled = true
//        view = mapView
//        
//        // todo: query the database and get the location of posts
//        let markerPositions : [CLLocation] = [CLLocation(latitude: 37.868485, longitude: -122.263885),
//                                              CLLocation(latitude: 37.862127, longitude: -122.258856),
//                                              CLLocation(latitude: 37.868725, longitude: -122.259274),
//                                              CLLocation(latitude: 37.866082, longitude: -122.248105),
//                                              CLLocation(latitude: 37.861413, longitude: -122.258043),
//                                              CLLocation(latitude: 37.861426, longitude:  -122.257646),
//                                              CLLocation(latitude: 37.868485, longitude: -122.263885)]
//        
//        for var position in markerPositions {
//            // Creates a marker in the center of the map.
//            let marker = GMSMarker()
//            marker.position = CLLocationCoordinate2D(latitude: position.coordinate.latitude, longitude: position.coordinate.longitude)
//            marker.title = "Sydney"
//            marker.snippet = "Australia"
//            marker.map = mapView
//            
//        }
//        
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

//
//  ExploreViewController.swift
//  RndrApp
//
//  Created by William Smith on 11/12/16.
//  Modified by Gera Groshev
//  Copyright © 2016 William Smith. All rights reserved.
//

import UIKit
import GoogleMaps


class ExploreViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mapView
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        var currentLocation : CLLocation!
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized) {
            currentLocation = locationManager.location
        }
        else {
            currentLocation = CLLocation(latitude: 37.868485, longitude: -122.26385)
        }
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        
        //
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        
        // todo: query the database and get the location of posts
        let markerPositions : [CLLocation] = [CLLocation(latitude: 37.868485, longitude: -122.263885),
                                              CLLocation(latitude: 37.862127, longitude: -122.258856),
                                              CLLocation(latitude: 37.868725, longitude: -122.259274),
                                              CLLocation(latitude: 37.866082, longitude: -122.248105),
                                              CLLocation(latitude: 37.861413, longitude: -122.258043),
                                              CLLocation(latitude: 37.861426, longitude:  -122.257646),
                                              CLLocation(latitude: 37.868485, longitude: -122.263885)]
        
        for var position in markerPositions {
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: position.coordinate.latitude, longitude: position.coordinate.longitude)
            marker.title = "Sydney"
            marker.snippet = "Australia"
            marker.map = mapView
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
        mapView.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 15.0)
        mapView.settings.myLocationButton = true
    }
    
    // MARK: CLLocationManagerDelegate methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.isMyLocationEnabled = true
        }
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
    */
}
