//
//  MenuCell.swift
//  Project3
//
//  Created by Shane Bersiek on 11/7/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    
    
    
  
    
    @IBOutlet var imageIcon: UIImageView!
    
    
    @IBOutlet var labelMenu: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
