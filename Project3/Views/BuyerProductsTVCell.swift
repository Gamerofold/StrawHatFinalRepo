//
//  BuyerProductsTVCell.swift
//  Project3
//
//  Created by Shane Bersiek on 11/1/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//

import UIKit
import STRatingControl

class BuyerProductsTVCell: UITableViewCell, STRatingControlDelegate {

  
    
    //MARK: Properties
    @IBOutlet weak var buyerItemImage: UIImageView!
    
    @IBOutlet weak var buyerLabel: UILabel!
    
    @IBOutlet weak var buyerDescriptionLabel: UILabel!
    // this does not know what its delegate is and since cells dont a have a view did load func were you can set its delegate to self, I set it up when the cell gets created in buyer tvc controller
    @IBOutlet var myRating: STRatingControl!
   
    
    ///MARK: rating keys
//    rating : Rating value, can be set or get current value
//    maxRating : Maximum rating value
//    filledStarImage : Image for filled rating stars
//    emptyStarImage : Image for empty rating stars
//    spacing : Space between rating stars
  func didSelectRating(_ control: STRatingControl, rating: Int) {
        print("RATING SELECTED \(rating)")
    
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
