//
//  StatusTableViewCell.swift
//  RndrApp
//
//  Created by William Smith on 11/12/16.
//  Copyright © 2016 William Smith. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trendingCellTextField: UILabel!
    
    @IBOutlet weak var trendingCellIcon: UIImageView!
    
    //@IBOutlet weak var friendsCellTextField: UILabel!
    
    //@IBOutlet weak var friendsCellImage: UIImageView!
    
    var favorite = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
