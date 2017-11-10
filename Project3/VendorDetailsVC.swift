//
//  VendorDetailsVC.swift
//  StrawHatLogIn
//
//  Created by Robert Whitehead on 11/7/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class VendorDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var passedID = 0
    var totalRows = 7
    var inventoryCount = 1
    var userVendorID = 0
    var userStoreItemID = ""
    var imagesDict: Dictionary = ["defaultPhoto.png": UIImage(named: "defaultPhoto")!]
    let storageRef = Storage.storage().reference()
    let refImageList = Database.database().reference(withPath: "image-list")
    let refIDs = Database.database().reference(withPath: "IDs")
    var allDatabaseIDs = generateNewID(buyer: 1000, vendor: 2000, purchase: 3000, order: 4000, store: 5000)
    let refOrders = Database.database().reference(withPath: "orders")
    var storeOrders: [Order] = []
    let refStore = Database.database().reference(withPath: "store")
    var storeItems: [Store] = []
    let refPurchase = Database.database().reference(withPath: "purchase")
    var storePurchases: [Purchases] = []
    let refBuyer = Database.database().reference(withPath: "buyers")
    var storeBuyers: [Buyer] = []
    let refVendor = Database.database().reference(withPath: "vendors")
    var storeVendors: [Vendor] = []
    
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib.init(nibName: "VendorMainDetailsCell", bundle: nil), forCellReuseIdentifier: "VendorMainDetailCell")
        tableView.register(UINib.init(nibName: "VendorReviewDetailsCell", bundle: nil), forCellReuseIdentifier: "VendorReviewDetailCell")
        tableView.register(UINib.init(nibName: "VendorImagesDetailCell", bundle: nil), forCellReuseIdentifier: "VendorImagesDetailsCell")
        tableView.register(UINib.init(nibName: "VendorSalesDetailTVCell", bundle: nil), forCellReuseIdentifier: "VendorSalesDetailCell")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return totalRows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier2", for: indexPath)
        let iRow = indexPath.row
        switch iRow {
        case 0:
// Main info & Descriptions
            let cellIdentifier = "VendorMainDetailCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VendorMainDetailsCell  else {
                fatalError("The dequeued cell is not an instance of VendorMainDetailCell.")
            }
            cell.nameText.text = storeItems[passedID].nameOfProduct
            cell.priceText.text = String(format: "$%.2f",storeItems[passedID].price)
            cell.idLabel.text = storeItems[passedID].key
            cell.descriptionText.text = storeItems[passedID].description
            cell.quantityText.text = String(storeItems[passedID].quantity) + " in stock"
            return cell
        case 1:
            // ratings/reviews
            let cellIdentifier = "VendorReviewDetailCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VendorReviewDetailsCell else {
                fatalError("The dequeued cell is not an instance of VendorImagesDetailCell.")
            }
            return cell

        case _ where iRow < 4:
// Images
            let cellIdentifier = "VendorImagesDetailsCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VendorImagesDetailCell else {
                fatalError("The dequeued cell is not an instance of VendorImagesDetailCell.")
            }
            if iRow == 2 {
                cell.photoImage.image = imagesDict[storeItems[passedID].imageName]
                cell.imageNumLabel.text = "main image"
            } else {
                cell.imageNumLabel.text = "alt image"
            }
            return cell
        default:
// Sales
            let cellIdentifier = "VendorSalesDetailCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VendorSalesDetailTVCell else {
                fatalError("The dequeued cell is not an instance of VendorImagesDetailCell.")
            }
            return cell
        }

        // Configure the cell...
        
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
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "VendorHomeSegue" {
            let VendorMain = segue.destination as! VendorHomeVC
     
            VendorMain.storeItems = storeItems
            VendorMain.storeBuyers = storeBuyers
            VendorMain.storePurchases = storePurchases
            VendorMain.storeVendors = storeVendors
            VendorMain.storeOrders = storeOrders
            VendorMain.allDatabaseIDs = allDatabaseIDs
            VendorMain.imagesDict = imagesDict
            VendorMain.inventoryCount = inventoryCount
     
        }
     }
 

}
