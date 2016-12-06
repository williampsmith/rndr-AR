import UIKit
import GoogleMaps


class ExploreViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mapView
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        var currentLocation : CLLocation!
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized) {
            currentLocation = self.locationManager.location
        }
        else {
            currentLocation = CLLocation(latitude: 37.868485, longitude: -122.26385)
        }
        while (currentLocation == nil) {
            currentLocation = self.locationManager.location
        }
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        
        
        //////////// EXAMPLE CODE FOR QUERYING THE DATABASE /////////////
        var markerPositions : [CLLocation] = []
        var dataManager = DataManager()
        dataManager.retrieveNearbyPosts()
        
        print("\n\n --------Populating nearby posts------- \n\n")
        print("Number of posts nearby: \(dataManager.nearbyPosts.count)")
        for var post in dataManager.nearbyPosts {
            let lat = Double(post.location[0])
            let lon = Double(post.location[1])
            print("location[0]: \(lat), \(lon)")
            print("data type: \(type(of: lat))\n\n")
            markerPositions.append(CLLocation(latitude: lat, longitude: lon))
            //print("\n\nLat long from retrieved posts for map view: \(lat), \(lon)")
        }
        
//        let markerPositions : [CLLocation] = [CLLocation(latitude: 37.868485, longitude: -122.263885),
//                                              CLLocation(latitude: 37.862127, longitude: -122.258856),
//                                              CLLocation(latitude: 37.868725, longitude: -122.259274),
//                                              CLLocation(latitude: 37.866082, longitude: -122.248105),
//                                              CLLocation(latitude: 37.861413, longitude: -122.258043),
//                                              CLLocation(latitude: 37.861426, longitude:  -122.257646),
//                                              CLLocation(latitude: 37.868485, longitude: -122.263885)]
        
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
