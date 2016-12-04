//
//  Post.swift
//  RndrApp
//
//  Created by William Smith on 11/12/16.
//  Copyright © 2016 William Smith. All rights reserved.
//

import UIKit

class Post: NSObject {
    
    enum PostType : String {
        case text
        case image
        case video
        case gif
        case object
    }
    
    init(author : NSString, time : Int, type : PostType, text: NSString, url : NSString, location : [Double], marker : NSString) {
        self.author = author
        self.time = time
        self.type = type
        self.text = text
        self.url = url
        self.location = location
        self.marker = marker
    }
    
    var author : NSString
    var time : Int?
    var type : PostType
    var text : NSString
    var url : NSString
    var location : [Double]
    var marker : NSString
}


