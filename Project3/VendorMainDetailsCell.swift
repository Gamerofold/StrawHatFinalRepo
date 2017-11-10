//
//  VendorMainDetailsCell.swift
//  StrawHatLogIn
//
//  Created by Robert Whitehead on 11/8/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//

import UIKit

class VendorMainDetailsCell: UITableViewCell {

    @IBOutlet var nameText: UITextField!
    @IBOutlet var priceText: UITextField!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var quantityText: UITextField!
    @IBAction func editButton(_ sender: UIButton) {
    }
    @IBOutlet var editOutetButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
