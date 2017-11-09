//
//  NonVendorTViewCell.swift
//  StrawHatLogIn
//
//  Created by Robert Whitehead on 11/8/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//

import UIKit

class NonVendorTViewCell: UITableViewCell {

    @IBOutlet var photoImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var vendorLabel: UILabel!
    @IBOutlet var descriptionText: UITextView!

    @IBOutlet var stockLabel: UILabel!
    @IBOutlet var salesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
