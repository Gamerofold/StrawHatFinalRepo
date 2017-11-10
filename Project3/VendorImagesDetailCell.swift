//
//  VendorImagesDetailCell.swift
//  StrawHatLogIn
//
//  Created by Robert Whitehead on 11/8/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//

import UIKit

class VendorImagesDetailCell: UITableViewCell {

    @IBOutlet var imageNumLabel: UILabel!
    @IBOutlet var photoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
