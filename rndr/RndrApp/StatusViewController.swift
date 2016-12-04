//
//  StatusViewController.swift
//  RndrApp
//
//  Created by William Smith and Robert Spark on 11/12/16.
//  Copyright © 2016 William Smith and Robert Spark. All rights reserved.
//

import UIKit

class Update {
    var name : String = ""
    var distance : Double = 1.0
    var favorite = false
    
    init(name : String, distance : Double) {
        self.name = name
        self.distance = distance
    }
}

class StatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    var trendingSelected = true
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    //some sample data to populate the tableview
    var updates : [Update] = [Update(name : "Will", distance: 2.0), Update(name : "Georgy", distance : 5.1), Update(name : "Bryce", distance : 1.1), Update(name: "Gera", distance : 0.4)] // for hacking only

    var savedPosts = [Update]() //will save removed posts from discover tab
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let leftImage = UIImage(named: "trending_icon.png")
        let rightImage = UIImage(named: "friends.png")
        segmentedControl.setImage(leftImage, forSegmentAt: 0)
        segmentedControl.setImage(rightImage, forSegmentAt: 1)

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
            } else {
                self.savedPosts.remove(at: indexPath.row)
            }
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        remove.backgroundColor = UIColor.red
        
        //save button actions (only for trending tableview)
        let save = UITableViewRowAction(style: .normal, title: "Save") { action, index in
            print("Save button tapped, moved obj to saved list")
            self.savedPosts.append(self.updates.remove(at: indexPath.row))
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                
        }
        save.backgroundColor = UIColor.lightGray
        
        if trendingSelected {
            return [remove, favorite, save]
        } else {
            return [remove, favorite]
        }
    }
    
    
    
    
    // MARK: TableView Functions
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // the cells you would like the actions to appear for needs to be editable
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        var currentUpdate = Update(name:"",distance:0)
        if self.trendingSelected {
            currentUpdate = updates[indexPath.row]
        } else {
            currentUpdate = savedPosts[indexPath.row]
        }
        if currentUpdate.favorite {
            cell.trendingCellIcon.image = UIImage(named: "yellow_star.png")
        }
        cell.trendingCellTextField.text = "\(currentUpdate.name) made a post \(currentUpdate.distance) miles from you."
        return cell
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
