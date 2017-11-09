//
//  ShoppingCartTableViewController.swift
//  StrawHatLogIn
//
//  Created by Sean Bukich on 11/6/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct QuantityCell {
    let quantity: Int
}
struct ItemDetailCell {
    let nameOfProduct: String
    let price: Float
}
struct SubTotalAndTaxCell {
    let subTotal: Float
    let shipAndHandle: Float
    let tax: Float
}
struct EndTotalCell {
    let endTotal: Float
}
struct CheckoutButton {
    let checkoutButton: UIButton!
}

class ShoppingCartTableViewController: UITableViewController {
    
    var ref: DatabaseReference?
    
    var arrayOfCellData = [QuantityCell.self,
                           ItemDetailCell.self,
                           SubTotalAndTaxCell.self,
                           EndTotalCell.self,
                           CheckoutButton.self] as [Any]
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenus()
        ref = Database.database().reference()
        
        arrayOfCellData = [QuantityCell(quantity: 1),
                           ItemDetailCell(nameOfProduct : "Atari 2600", price : 100),
                           SubTotalAndTaxCell(subTotal: 100.00, shipAndHandle: 0.0, tax: 3),
                           EndTotalCell(endTotal: 103),
                           CheckoutButton( checkoutButton: nil)]
        
        self.tableView.register(UINib(nibName: "NumberOfItemsCell", bundle: nil), forCellReuseIdentifier: "NumberOfItemsCell")
        self.tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemTableViewCell")
        self.tableView.register(UINib(nibName: "CartDetailCell", bundle: nil), forCellReuseIdentifier: "CartDetailCell")
        self.tableView.register(UINib(nibName: "CartTotalCell", bundle: nil), forCellReuseIdentifier: "CartTotalCell")
        self.tableView.register(UINib(nibName: "CheckOutButtonCell", bundle: nil), forCellReuseIdentifier: "CheckOutButtonCell")
        
    }
    func sideMenus() {
        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell: UITableViewCell
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NumberOfItemsCell", for: indexPath) as! NumberOfItemsCell
            
            let myQty = (arrayOfCellData[0] as! QuantityCell).quantity
            
            cell.itemCountCart.text = "\(myQty)"
            
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell
            
            let itmName = (arrayOfCellData[1] as! ItemDetailCell).nameOfProduct
            let itmPrice = (arrayOfCellData[1] as! ItemDetailCell).price
            
            cell.itemName.text = "\(itmName)"
            cell.itemPrice.text = "\(itmPrice)"
            
            return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartDetailCell", for: indexPath) as! CartDetailCell
            
            let subTtl = (arrayOfCellData[2] as! SubTotalAndTaxCell).subTotal
            let shpAndHandle = (arrayOfCellData[2] as! SubTotalAndTaxCell).shipAndHandle
            let tax = (arrayOfCellData[2] as! SubTotalAndTaxCell).tax
            
            cell.subtotalCartTextField.text = "\(subTtl)"
            cell.shipAndHandleCartTextField.text = "\(shpAndHandle)"
            cell.taxCartTextField.text = "\(tax)"
            
            return cell
            
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartTotalCell", for: indexPath) as! CartTotalCell
            
            let endTtl = (arrayOfCellData[3] as! EndTotalCell).endTotal
            
            cell.totalCartTextField.text = "\(endTtl)"
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckOutButtonCell", for: indexPath) as! CheckOutButtonCell
            
            return cell
            
        }
        
    }
    
}


