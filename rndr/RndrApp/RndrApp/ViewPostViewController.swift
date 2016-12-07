//
//  ViewPostViewController.swift
//  RndrApp
//
//  Created by Robert Spark on 12/1/16.
//  Modified by William Smith on 12/3/16.
//  Copyright © 2016 Robert Spark and William Smith. All rights reserved.
//

import UIKit
import Firebase

class ViewPostViewController: UIViewController {
    var post: Post = Post(author: "", time: 0, type: Post.PostType.text, text: "", url: "", location: [0.0,0.0], marker: "")

    @IBOutlet weak var setTitle: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setTitle.text = (self.post.author as String) + " 's post"
        self.textView.text = post.text as String
        
        self.textView.font = UIFont(name: self.textView!.font!.fontName, size: 18)
        self.textView.textAlignment = .center
        
        let storageRef = FIRStorage.storage().reference(forURL: "gs://rndr-77d10.appspot.com")
        
        if self.post.type == .image {
            print("\nThis post has an image! Downloading....\n")
            self.downloadImage(newPost: self.post, storageRef: storageRef)
        }
    }
    
    func downloadImage(newPost : Post, storageRef: FIRStorageReference) {
        
        let downloadedImage = storageRef.child(newPost.url as String)
        print("\n\nIn Download beginning...\n\n")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        downloadedImage.data(withMaxSize: 100 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                print("\nDownload error occured: \(error)\n")
            } else {
                print("\nImage downloaded successfully!!\n)")
                // Data for "images/island.jpg" is returned
                self.imageView.image = UIImage(data: data!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
