//
//  CreateViewController.swift
//  RndrApp
//
//  Created by William Smith on 11/12/16.
//  Modified by Robert Spark 11/28/16.
//  Copyright © 2016 William Smith and Robert Spark. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase


class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var dataManager = DataManager()
    var location : CLLocation = CLLocation()
    
    //let storage =  // for accessing firebase storage root
    
    // firebase root
    
    // MARK: Properties
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextField: UITextView!
    @IBOutlet weak var stackview: UIStackView!
    
    var imagePicker = UIImagePickerController()
    var edits = false
    var initialLoad = true // ensures location updates do not continuously call DataManager delegates
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //4, 6, 22, 0.94
//        self.view.backgroundColor = UIColor(red: 4 / 255.0, green: 6 / 255.0, blue: 22 / 255.0, alpha: 0.94)
//        self.stackview.backgroundColor = UIColor(red: 4 / 255.0, green: 6 / 255.0, blue: 22 / 255.0, alpha: 0.54)
//        
        initialLoad = true
        
        imagePicker.delegate = self
        postTextField.delegate = self
        self.locationManager.delegate = self
        
        registerForKeyboardNotifications()
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(CreateViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //registerForKeyboardNotifications()
    }
    
    // MARK: Keyboard handler
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        edits = true
        print("\nKeyboard was shown.\n")
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let delta = keyboardSize!.height - 150
        let oframe = self.stackview.frame
        self.stackview.frame = CGRect(x: oframe.minX, y: oframe.minY - delta, width: oframe.width, height: oframe.height)
    }
    
    func keyboardWillBeHidden(_ notification: NSNotification){
        //Once keyboard disappears, restore original positions
        print("Hide keyboard now.")
        self.view.endEditing(true)
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let delta = keyboardSize!.height - 150
        let oframe = self.stackview.frame
        self.stackview.frame = CGRect(x: oframe.minX, y: oframe.minY + delta, width: oframe.width, height: oframe.height)
    }
    
    func didTapView(){
        if edits == true {
            self.view.endEditing(true)
            print("clicked out of keyboard")
            edits = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        postTextField = textView
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print(textView.text)
        print("textViewDidEndEditing")
    }
    
    // MARK: Actions
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // default location
        self.location = CLLocation(latitude: 37.868485, longitude: -122.26385)
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized) {
            self.locationManager.requestLocation()
        }
        else {
            print("\n\nError: Not authorized to retrieve location data. Using default location for post retrieval.\n\n")
            
            // create new post here
            self.createAndPost()
        }
        
    }
    
    // Mark: CLLocationManagerDelegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if initialLoad {
            initialLoad = false
            
            self.location = locations[0]
            print("\n\nPreparing for post.\n\n")
            self.createAndPost()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\n\nFailed to get location. Error: \(error)\n\n")
    }
    
    func createAndPost() {
        
        let lat = Double((location.coordinate.latitude))
        let lon = Double((location.coordinate.longitude))
        let currentLocation = [lat, lon] //todo: updte from CoreLocation
        let currentTime = 0 //todo: fix me
        
        print("Location Lat and long: \(lat), \(lon)")
        
        let newPost = Post(author : "William", time : currentTime, type : Post.PostType.text, text: postTextField.text as NSString, url : "", location : currentLocation, marker : "William")
        
        // handle images if neccesary
        if postImageView.image == nil {
            dataManager.savePost(newPost: newPost)
        } else {
            self.uploadPhoto(newPost : newPost) // this also saves the post
        }
        
        
        print("Post button pushed. This is for debugging.")
    }
    
    func uploadPhoto(newPost : Post) { // uploads directly to firebase
        // create the post
        let storageRef = FIRStorage.storage().reference(forURL: "gs://rndr-77d10.appspot.com")
        
        newPost.type = .image // set to image type
        
        //todo: check the /images. Not sure if this is correct url
        let timeTag = String(Int(NSDate().timeIntervalSince1970 * 100000)) // unique tag
        newPost.url = "images/\(timeTag).jpg" as NSString //"gs://rndr-77d10.appspot.com/images/\(timeTag).jpg" as NSString
        let imageRef = storageRef.child("images/\(timeTag).jpg")
        let imageData : Data = UIImagePNGRepresentation(postImageView.image!)! as Data
        
        let uploadTask = imageRef.put(imageData, metadata: nil) { metadata, error in
            if (error != nil) {
                print("\nError occured during creation of the upload task.\n")
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL // which dl url to use?
                
                //                // todo: change this to commented value. Temporary
                //                newPost.url = "gs://rndr-77d10.appspot.com/images/\(timeTag).jpg" as NSString
                //                //NSString(downloadURL)// as NSString
                
                self.dataManager.savePost(newPost: newPost)
            }
        }
        
        uploadTask.observe(.pause) { snapshot in
            // Upload paused
            print("\n\nUpload status change: Upload paused\n\n")
        }
        
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
            print("\n\nUpload status change: Upload resumed\n\n")
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            if let progress = snapshot.progress {
                let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                print("Upload status: \(percentComplete) % complete\n")
            }
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            print("\nUpload Completed Successfully!!\n")
            
            //todo: FOR TESTING ONLY
            //print("\nRunning download test on URL: \(newPost.url)")
            //self.runDownloadTest(newPost: newPost, storageRef : storageRef)
        }
        
        // Errors only occur in the "Failure" case
        uploadTask.observe(.failure) { snapshot in
            guard let storageError = snapshot.error else { return }
            guard let errorCode = FIRStorageErrorCode(rawValue: storageError._code) else { return }
            switch errorCode {
            case .objectNotFound:
                // File doesn't exist
                print("Error: Could not upload photo. File does not exist.")
                
            case .unauthorized:
                // User doesn't have permission to access file
                print("Error: Could not upload photo. Unauthorized.")
                
            case .cancelled:
                // User canceled the upload
                print("Error: Could not upload photo. Upload Cancelled.")
                
            case .unknown:
                // Unknown error occurred, inspect the server response
                print("Error: Could not upload photo. Reason unknown.")
            default:
                // Unknown error occurred, inspect the server response
                print("Error: Could not upload photo. Reason unknown.")
            }
        }
    }
    
    // test function for downloading and testing correct URL
//    func runDownloadTest(newPost : Post, storageRef: FIRStorageReference) {
//        
//        let downloadedImage = storageRef.child(newPost.url as String)
//        print("\n\nIn Download beginning...\n\n")
//        
//        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//        downloadedImage.data(withMaxSize: 100 * 1024 * 1024) { (data, error) -> Void in
//            if (error != nil) {
//                print("\nDownload error occured: \(error)\n")
//            } else {
//                print("\nImage downloaded successfully!!\n)")
//                // Data for "images/island.jpg" is returned
//                let islandImage: UIImage! = UIImage(data: data!)
//            }
//        }
//    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        //let dataManager = DataManager()
        //dataManager.changeMetadataAsync(newMetadata: "0")
        print("Cancel button pressed. This is for debugging.")
    }
    
    //todo: get rid of this ?
    @IBAction func letdataManagerDataManagerpostButtonPressed(_ sender: Any) {
    }
    
    @IBAction func importPhotoButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true // reactivate if we weant to crop
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: Image Picker
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        postImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
        print((info))
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
