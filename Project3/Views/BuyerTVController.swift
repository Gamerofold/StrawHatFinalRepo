//
//  BuyerTVController.swift
//  Project3
//
//  Created by Shane Bersiek on 11/1/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//

import UIKit
import STRatingControl
import Firebase
import FirebaseDatabase

enum Section: Int {
    case createNewChannelSection = 0
    case currentChannelsSection = 1
}


class BuyerTVController: UITableViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    
    
    
    
    //MARK: firebase properties
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("store")
    private var channelRefHandle: DatabaseHandle?
   // var storeChannelRef = Database.database().reference(withPath: "store")
    //Properties
    var mySectionsCount = Int()
    var newChannelTextField: UITextField?
    var arrayOfProducts = [BuyerProducts]()
    
    var userEmail: String = ""
    var buyerFlag: Bool = false
    var vendorFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FirebaseApp.configure()

        
        sideMenus()
        observeChannels()
        
        print(userEmail)
        print(buyerFlag)
        print(vendorFlag)
        
       
        self.tableView.reloadData()
        
    }
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
  
   
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        self.mySectionsCount = Int(section)
        
        if let currentSection: Section = Section(rawValue: section) {
            switch currentSection {
            case .createNewChannelSection:
                return 1
            case .currentChannelsSection:
                return arrayOfProducts.count
            }
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let currentSection: Section = Section(rawValue: indexPath.section) {
            switch currentSection {
            case .createNewChannelSection:
                return 45.00
            case .currentChannelsSection:
                return 90.00
            }
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Creating a reuse identifier String that will change
        let reuseIdentifier = (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue ? "firstCell" : "secondCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        
        if indexPath.section == Section.createNewChannelSection.rawValue {
            if let createNewChannelCell = cell as? BuyersSearchTVCell {
              newChannelTextField = createNewChannelCell.buyerSearchTxtField
            }
        } else if indexPath.section == Section.currentChannelsSection.rawValue {
            if let productListCell = cell as? BuyerProductsTVCell {
                
                ///this is setting the delegate to the cell
                productListCell.myRating.delegate = productListCell
                
                productListCell.buyerItemImage.image = arrayOfProducts[indexPath.row].photo
                productListCell.buyerLabel.text = arrayOfProducts[indexPath.row].label
                productListCell.buyerDescriptionLabel.text = arrayOfProducts[indexPath.row].description
                
               return productListCell
            }
            
        }

        return cell
    }

    
    @IBAction func buyersSearchBtn(_ sender: Any) {
    
        
        ///make a function to filter results
    }
    
    
    
    //MARK: firebase functions
    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        
        // 1 You call observe:with: on your channel reference, storing a handle to the reference. This calls the completion block every time a new channel is added to your database.
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            // 2 The completion receives a FIRDataSnapshot (stored in snapshot), which contains the data and other helpful methods.
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            //let id = snapshot.key
            // 3 You pull the data out of the snapshot and, if successful, create a Channel model and add it to your channels array.
            print("my snapshot \(channelData)")
           if let name = channelData["nameOfProduct"] as! String!, name.characters.count > 0 {
               let myDescription = channelData["description"] as! String!
            self.arrayOfProducts.append(BuyerProducts(photo: #imageLiteral(resourceName: "placeholder"), label: name, description: myDescription!))
            
               self.tableView.reloadData()
          } else {
             print("Error! Could not decode channel data")           }
        })
    }
    
    func sideMenus() {
        if revealViewController() != nil {
       
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
