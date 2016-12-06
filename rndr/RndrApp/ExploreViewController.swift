import UIKit
import GoogleMaps



class ExploreViewController: UIViewController, CLLocationManagerDelegate, DataManagerDelegate {
    
    var locationManager = CLLocationManager()
    var dataManager = DataManager()
    var currentLocation : CLLocation!
    var didFindMyLocation = false
    var mapView: GMSMapView!
    var initialLoad = true // ensures location updates do not continuously call DataManager delegates
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.dataManager.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // default location that will be changed asynchronously later
        currentLocation = CLLocation(latitude: 37.868485, longitude: -122.26385)
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
        // todo: uncomment after testing
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // request location service and update asynchronously
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized) {
            locationManager.requestLocation() // this will call delegate when retrieved
        }
        else {
            print("\n\nError: Not authorized to retrieve location data. Using default location for post retrieval.\n\n")
            self.dataManager.retrieveNearbyPosts()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func didRetrieveNearbyPosts(sender: DataManager) {
        
        //////////// EXAMPLE CODE FOR QUERYING THE DATABASE /////////////
        var markerPositions : [CLLocation] = []
        
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
        
        // try:
        DispatchQueue.main.async {
            for var position in markerPositions {
                // Creates a marker in the center of the map.
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: position.coordinate.latitude, longitude: position.coordinate.longitude)
                marker.title = "Sydney"
                marker.snippet = "Australia"
                marker.map = self.mapView
            }
        }
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if initialLoad {
            initialLoad = false
            
            //todo: check this array indexing to ensure correctness
            currentLocation = locations[0]
            
            // Create a GMSCameraPosition that tells the map to display the
            // coordinate -33.86,151.20 at zoom level 6.
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 15.0)
            mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapView.isMyLocationEnabled = true
            view = mapView
            
            mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
            
            self.dataManager.retrieveNearbyPosts()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\n\nFailed to get location. Error: \(error)\n\n")
    }

    
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
