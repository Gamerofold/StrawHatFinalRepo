//
//  VendorHomeVC.swift
//  StrawHatLogIn
//
//  Created by Robert Whitehead on 11/7/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class VendorHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    
    var userEmail = ""
    var passedID = 0
    var inventoryCount = 1
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       sideMenus()
        tableView.register(UINib.init(nibName: "NonVendorTViewCell", bundle: nil), forCellReuseIdentifier: "NonVendorTVCell")
        tableView.register(UINib.init(nibName: "VendorTViewCell", bundle: nil), forCellReuseIdentifier: "VendorTVCell")
        
//        tableView.estimatedRowHeight = 120
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        print(inventoryCount)
//        self.tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

//        // #warning Incomplete implementation, return the number of rows

        return  inventoryCount
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier1", for: indexPath)
        
        // Configure the cell...
        let iRow = indexPath.row
        let cellIdentifier = "NonVendorTVCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NonVendorTViewCell  else {
                    fatalError("The dequeued cell is not an instance of NonVendorCell.")
                    }
        if iRow < storeItems.count {
            if iRow % 3 == 0 {
                cell.vendorLabel.text = "Whitehead Arts & Media"
                cell.salesLabel.text = "Sales: 20 items  Total $99.03"
                cell.stockLabel.text = "Stock = 3 items"

            } else {
                cell.vendorLabel.text = "Bobby, Inc."
                cell.salesLabel.text = ""
                cell.stockLabel.text = ""

            }
            let nameFile = storeItems[iRow].imageName
            cell.photoImage.image = imagesDict[nameFile] //UIImage (named: nameFile)
            cell.priceLabel.text = String(format: "$%.2f",storeItems[iRow].price)
            cell.nameLabel.text = storeItems[iRow].nameOfProduct
            var textLittle = storeItems[iRow].description
            if textLittle.count > 99 {
                textLittle = textLittle.prefix(99) + "..."
            }
            cell.descriptionText.text = textLittle
        } else {
            
        }

        return cell
    }
    
    func sideMenus() {
        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passedID = indexPath.row
        performSegue(withIdentifier: "RowClickSegue", sender: self)
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
        if segue.identifier == "RowClickSegue" {
            let VendorDetails = segue.destination as! VendorDetailsVC
            
            VendorDetails.storeItems = storeItems
            VendorDetails.storeBuyers = storeBuyers
            VendorDetails.storePurchases = storePurchases
            VendorDetails.storeVendors = storeVendors
            VendorDetails.storeOrders = storeOrders
            VendorDetails.allDatabaseIDs = allDatabaseIDs
            VendorDetails.imagesDict = imagesDict
            VendorDetails.inventoryCount = inventoryCount
            VendorDetails.totalRows = 10
            VendorDetails.userVendorID = storeItems[passedID].vendorID
            VendorDetails.passedID = passedID
            VendorDetails.userStoreItemID = storeItems[passedID].key

        }
    }
    
    
}
