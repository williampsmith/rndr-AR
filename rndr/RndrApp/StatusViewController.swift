//
//  StatusViewController.swift
//  RndrApp
//
//  Created by William Smith and Robert Spark on 11/12/16.
//  Copyright © 2016 William Smith and Robert Spark. All rights reserved.
//

import UIKit
import CoreLocation

class Update {
    var name : String = ""
    var distance : Double = 1.0
    var favorite = false
    var closePost = false
    
    init(name : String, distance : Double, closePost : Bool) {
        self.name = name
        self.distance = distance
        self.closePost = closePost
    }
}

class StatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataManagerDelegate, CLLocationManagerDelegate {
    
    var initialLoad = true // ensures location updates do not continuously call DataManager delegates
    
    var dataManager = DataManager()
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation(latitude: 10.0, longitude: 10.0)
    
    //MARK: Properties
    var trendingSelected = true
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    //some sample data to populate the tableview
    var updates : [Update] = []
    var savedPosts = [Update]() //will save removed posts from discover tab
    var updatesWithPost : [Post] = []
    var savedPostsWithPost = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLoad = true
        
         //for testing only
        self.updates = [Update(name : "Will", distance: 2.0, closePost : false), Update(name : "Georgy", distance : 5.1, closePost : false), Update(name : "Bryce", distance : 1.1, closePost : false), Update(name: "Gera", distance : 0.4, closePost : false)]
        
        self.updatesWithPost.sort(by: { s1, s2 in return currentLocation.distance(from: CLLocation(latitude: s1.location[0], longitude: s1.location[1])) < currentLocation.distance(from: CLLocation(latitude: s2.location[0], longitude: s2.location[1]))})
        
        //sync two update list
        syncTwoUpdate()

        dataManager.delegate = self
        locationManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        let leftImage = UIImage(named: "trending_icon.png")
        let rightImage = UIImage(named: "friends.png")
        segmentedControl.setImage(leftImage, forSegmentAt: 0)
        segmentedControl.setImage(rightImage, forSegmentAt: 1)
        
        // location handling
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized) {
            locationManager.requestLocation() // this will call delegate when retrieved
        }
        else {
            print("\n\nError: Not authorized to retrieve location data. Using default location for post retrieval.\n\n")
            self.dataManager.retrieveNearbyPosts()
        }
    }
    
    // This function will sync two updates
    func syncTwoUpdate() {
        self.updates = []
        for post in updatesWithPost {
            let distance = self.currentLocation.distance(from: CLLocation(latitude: post.location[0], longitude: post.location[1]))
            let isClose = distance <= 200
            let newUpdate = Update(name : post.author as String, distance: distance, closePost : isClose)
            
            self.updates.append(newUpdate)
        }
    }

    //give options when swiping to the side on a UItableViewCell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let cell = self.tableView.cellForRow(at: indexPath) as! StatusTableViewCell
        var title = ""
        var list:[Update]?
        
        if self.trendingSelected {
            list = updates
        } else {
            list = savedPosts
        }
        
        if (list?[indexPath.row].favorite)! {
            title = "Uncheck"
        } else {
            title = "Favorite"
        }
        
        //favorite button actions
        let favorite = UITableViewRowAction(style: .normal, title: title) { action, index in
            
            print("Favorite button tapped")

            if !cell.favorite && !(list?[indexPath.row].favorite)! {
                cell.trendingCellIcon.image = UIImage(named: "yellow_star.png")
                list?[indexPath.row].favorite = true
                cell.favorite = true
            }
            else
            {
                list?[indexPath.row].favorite = false
                cell.favorite = false
                cell.trendingCellIcon.image = nil
            }
            self.tableView.reloadData()
        }
        
        favorite.backgroundColor = UIColor.orange
    
        //remove button actions
        let remove = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("Remove Post button tapped")
            if self.trendingSelected {
                self.updates.remove(at: indexPath.row)
                self.updatesWithPost.remove(at: indexPath.row)
            } else {
                self.savedPosts.remove(at: indexPath.row)
                self.savedPostsWithPost.remove(at: indexPath.row)
            }
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        
        remove.backgroundColor = UIColor.red
        
        //save button actions (only for trending tableview)
        let save = UITableViewRowAction(style: .normal, title: "Save") { action, index in
            print("Save button tapped, moved obj to saved list")
            self.savedPosts.append(self.updates.remove(at: indexPath.row))
            self.savedPostsWithPost.append(self.updatesWithPost.remove(at: indexPath.row))
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                
        }
        save.backgroundColor = UIColor.lightGray
        
        if trendingSelected {
            return [remove, favorite, save]
        } else {
            return [remove, favorite]
        }
    }
    
    
    func didRetrieveNearbyPosts(sender: DataManager) {
        self.updatesWithPost = dataManager.nearbyPosts
        self.updatesWithPost.sort(by: { s1, s2 in return currentLocation.distance(from: CLLocation(latitude: s1.location[0], longitude: s1.location[1])) < currentLocation.distance(from: CLLocation(latitude: s2.location[0], longitude: s2.location[1]))})
        
        syncTwoUpdate()
        self.tableView.reloadData()
    }
    
    
    // MARK: TableView Functions
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // the cells you would like the actions to appear for needs to be editable
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if trendingSelected {
            return updates.count
        } else {
            return savedPosts.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "trendingCell", for: indexPath) as! StatusTableViewCell
        
        // initial value
        var currentUpdate = Update(name : "", distance : 0, closePost : false)
        
        if self.trendingSelected {
            currentUpdate = updates[indexPath.row]
        } else {
            currentUpdate = savedPosts[indexPath.row]
        }
        if currentUpdate.favorite {
            cell.trendingCellIcon.image = UIImage(named: "yellow_star.png")
        }
        
        //TODO: need to check if it works!
        if currentUpdate.closePost {
            cell.backgroundColor = UIColor(red: 1.0, green: 51 / 255, blue: 51 / 255, alpha: 0.8)
        } else {
            cell.backgroundColor = UIColor.lightGray
        }
        
        
        cell.trendingCellTextField.text = "\(currentUpdate.name) made a post \(currentUpdate.distance) meters from you."
        return cell
    }
    
    // Perform the segue when a row is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row Selected")
        
        let currentUpdate = updates[indexPath.row]
        
        // if close enough to view post, allow segue
        if currentUpdate.closePost{
            performSegue(withIdentifier: "includesImage", sender: self)
        }
    }
    
    // MARK: - handle segues
    
    // Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "includesImage" {
            // Get the selected Post, by asking the table which row is selected
            let selectedRow = tableView.indexPathForSelectedRow!.row
            let selectedPost = self.updatesWithPost[selectedRow]
            print("inside prepare \(selectedPost.author)")
            
            // Get the destination view controller and set its movie property
            let detailController = segue.destination as! ViewPostViewController
            detailController.post = selectedPost
        }
    }
  
    // Mark: CLLocationManagerDelegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if initialLoad {
            initialLoad = false
            
            self.currentLocation = locations[0] // todo: check index assumptions
            dataManager.retrieveNearbyPosts()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\n\nFailed to get location. Error: \(error)\n\n")
    }
    
    
    // MARK: Actions
    @IBAction func segmentedControlToggled(_ sender: Any) {
        print("segmented button pressed.")
        trendingSelected = !trendingSelected
        self.tableView.reloadData()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
