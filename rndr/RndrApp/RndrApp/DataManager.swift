//
//  DataManager.swift
//  RndrApp
//
//  Created by William Smith on 11/12/16.
//  Copyright © 2016 William Smith. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation


class DataManager: NSObject {
    var locationManager = CLLocationManager()
    var nearbyPosts : [Post] = []
    
    func changeMetadataAsync(newMetadata: String) {
        var request = URLRequest(url: URL(string: "https://rndr-cal-hacks.azurewebsites.net/target")!)
        request.httpMethod = "POST"
        
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue("d440a2766ab3442297abf6f89807a15d", forKey: "id")
        para.setValue(newMetadata, forKey: "metadata")
        let jsonData = try! JSONSerialization.data(withJSONObject: para)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
        print(jsonString)
        
        //let postString = "{\"id\":\"d440a2766ab3442297abf6f89807a15d\", \"metadata\":\"" + newMetadata + "\"}"
        //print(postString)
        request.httpBody = jsonData
        
        let headers = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            print("Done!")
            print(data!)
            print(response!)
            }.resume()

    }

    
    func retieveNearbyPosts() {
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
        
        let lat = Double((currentLocation?.coordinate.latitude)!)
        let lon = Double((currentLocation?.coordinate.longitude)!)
        
        print("Lat and long: \(lat), \(lon)")
        
        let headers = [
            "cache-control": "no-cache"
        ]
        
        let url = URL(string: "https://rndrapp.herokuapp.com/posts/" + String(lat) + "/" + String(lon))
        
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            var json = try! JSONSerialization.jsonObject(with: data, options: [])
            print("The following is the retrieved nearby posts:")
            print(json)
            
            
            let jsonArr = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
            for js in jsonArr {
                // create new Post object
                var tempPost = Post(author: "", time: 0, type: .text, text: "", url: "", location: [0,0, 0,0], marker: "")
                
                // parse JSON and populate post object
                if let jsDict = js as? NSDictionary {
                    if let author = jsDict["author"] as? NSString {
                        tempPost.author = author
                    }
                    if let type = jsDict["type"] as? NSString {
                        tempPost.type = Post.PostType(rawValue: String(type))!
                    }
                    if let text = jsDict["text"] as? NSString {
                        tempPost.text = text
                    }
                    if let url = jsDict["url"] as? NSString {
                        tempPost.url = url
                    }
                    if let location = jsDict["location"] as? NSArray {
                        tempPost.location = location as! [Double]
                    }
                    if let marker = jsDict["marker"] as? NSString {
                        tempPost.marker = marker
                    }
                }
                
                self.nearbyPosts.append(tempPost)
            }
            
            print("\n\nSize of nearby posts: \(self.nearbyPosts.count)\n\n")
        }
        
        task.resume()
    }
    
    func savePost(newPost: Post) {
        
        var request = URLRequest(url: URL(string: "https://rndrapp.herokuapp.com/post/")!)
        request.httpMethod = "POST"
        
        let para: NSMutableDictionary = NSMutableDictionary()
        let locX = newPost.location[0]
        let locY = newPost.location[1]
        //let locationString = "[\(String(locX) as NSString), \(String(locY) as NSString)]"
        //print("Location String: \(locationString)")
        print("Type: \(newPost.type.rawValue as NSString)")
        print("Type type: \(type(of: (newPost.type.rawValue as NSString)))")
        
        // create dictionary to be converted to json for http body
        para.setValue(newPost.author, forKey: "author")
        para.setValue((newPost.type.rawValue as NSString), forKey: "type")
        para.setValue(newPost.text, forKey: "text")
        para.setValue(newPost.url, forKey: "url") //todo: add URL of image from firebase
        //para.setValue(locationString, forKey: "location")
        para.setValue([locX, locY], forKey: "location")
        para.setValue(newPost.marker, forKey: "marker")
        
        
        let jsonData = try! JSONSerialization.data(withJSONObject: para)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
        print("JSON String: \(jsonString)")
        
        request.httpBody = jsonData
        
        let headers = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            print("Done posting!")
            print("Data: \(data!)")
            print("Response: \(response!)")
            }.resume()
    }
}








