//
//  ViewPostViewController.swift
//  RndrApp
//
//  Created by Robert Spark on 12/1/16.
//  Copyright © 2016 Robert Spark. All rights reserved.
//

import UIKit

class ViewPostViewController: UIViewController {
    var post: String!

    @IBOutlet weak var setTitle: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setTitle.text = self.post + " 's post"
        self.imageView.image = nil
        self.textView.text = "get something here"

        
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
