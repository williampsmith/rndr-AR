//
//  DataManager.swift
//  RndrApp
//
//  Created by William Smith on 11/12/16.
//  Copyright © 2016 William Smith. All rights reserved.
//

import UIKit
import Foundation

class DataManager: NSObject {
    
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
    
    func getLocation() {
        
    }

    
    func retieveNearbyPosts() {
        //todo: Get current location
        // Right now it's hardcoded.
        let lat = 20.0
        let lon = 20.0
        
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
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            print("The following is the retrieved nearby posts:")
            print(json)
            
            // convert json into post objects here
        }
        
        task.resume()
    }
    
    func savePost(newPost: Post) {
//        let url = URL(string: "https://rndrapp.herokuapp.com/posts/")
//        var request = URLRequest(url: url!)
//        
//        let postString = "author=\(newPost.author)&type=\(newPost.type)&text=\(newPost.text)&url=&location=[\(newPost.location[0]),\(newPost.location[1])]&marker=ID"
//        
//        print("Post String: \(postString)")
//        
//        request.httpBody = postString.data(using: .utf8)
//        print("http body: \(request.httpBody!)")
//        
//        // check for fundamental networking errors
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard error == nil else {
//                print("error = \(error)")
//                return
//            }
//            guard let data = data else {
//                print("Data is empty")
//                return
//            }
//            
//            // check for http errors
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
//            }
//            
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(responseString)")
//        }
//        
//        // todo: uncomment me later!
//        task.resume()
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








