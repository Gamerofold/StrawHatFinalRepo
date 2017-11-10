//
//  VendorTempViewController.swift
//  Project3
//
//  Created by Robert Whitehead on 11/9/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class VendorTempViewController: UIViewController {

    var inventoryCount = 38
    var buyerSigninID = ""
    var vendorSigninID = ""
    var allLoaded = 0
    var userEmail = ""
    var buyerLogin = true
    var imagesDict: Dictionary = ["defaultPhoto.png": UIImage(named: "defaultPhoto")!]
    var allDatabaseIDs = generateNewID(buyer: 1000, vendor: 2000, purchase: 3000, order: 4000, store: 5000) // dummy/temp variables
    var storeOrders: [Order] = []
    var storeItems: [Store] = []
    var storePurchases: [Purchases] = []
    var storeBuyers: [Buyer] = []
    var storeVendors: [Vendor] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let user = Auth.auth().currentUser
        var userEmail = ""
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            userEmail = user.email!
            
            // ...
        }
        buyerSigninID = ""
        vendorSigninID = ""
        allLoaded = 0
        buyerLogin = true
        getImages()
        let refIDs = Database.database().reference(withPath: "IDs")
        refIDs.observe(.value, with: { snapshot in
            let storageRef = Storage.storage().reference()
            let refImageList = Database.database().reference(withPath: "image-list")
            let refIDs = Database.database().reference(withPath: "IDs")
            let refOrders = Database.database().reference(withPath: "orders")
            let refStore = Database.database().reference(withPath: "store")
            let refPurchase = Database.database().reference(withPath: "purchase")
            let refBuyer = Database.database().reference(withPath: "buyers")
            let refVendor = Database.database().reference(withPath: "vendors")
            refBuyer.queryOrdered(byChild: "buyers").observe(.value, with: { snapshot in
                var newBuyers: [Buyer] = []
                for item in snapshot.children {
                    let newBuyer = Buyer(snapshot: item as! DataSnapshot)
                    newBuyers.append(newBuyer)
                }
                self.storeBuyers = newBuyers
                self.buyerSigninID = ""
                for items in self.storeBuyers {
                    if items.email == userEmail {
                        self.buyerSigninID = items.key
                    }
                }
                self.checkForSegue()
                //                self.tableView.reloadData()
            })
            refVendor.queryOrdered(byChild: "vendors").observe(.value, with: { snapshot in
                var newVendors: [Vendor] = []
                for item in snapshot.children {
                    let newVendor = Vendor(snapshot: item as! DataSnapshot)
                    newVendors.append(newVendor)
                }
                self.storeVendors = newVendors
                self.vendorSigninID = ""
                for items in self.storeBuyers {
                    if items.email == userEmail {
                        self.vendorSigninID = items.key
                    }
                }
                self.checkForSegue()
                //                self.tableView.reloadData()
            })
            refImageList.queryOrdered(byChild: "image-list").observe(.value, with: { snapshot in
                
                // Get image names
                let value = snapshot.value as? NSDictionary
                let filename = value?["names"] as? [String] ?? ["defaultPhoto.png"]
                
                //                for item in snapshot.children {
                //                    let newNames = ImageList(snapshot: item as! DataSnapshot)
                //                    self.imagesList = newNames
                //                }
                // Create a reference to the file you want to download
                let tImage = UIImage(named: "defaultPhoto")
                for item in filename {
                    let imageRef = storageRef.child("images/" + item)
                    
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            self.imagesDict[item] = tImage
                        } else {
                            self.imagesDict[item] = UIImage(data: data!)
                        }
                    }
                }
                self.checkForSegue()
//                for fileN in filename {
//                    print(fileN) // = UIImage(named: fileN)
//                }
            })
            refIDs.queryOrdered(byChild: "IDs").observe(.value, with: { snapshot in
                //                var newIDs: [generateNewID] = []
                for item in snapshot.children {
                    let newIDs = generateNewID(snapshot: item as! DataSnapshot)
                    self.allDatabaseIDs = newIDs
                }
                self.checkForSegue()
                //                self.allIDs = newIDs[0]
                //                self.tableView.reloadData()
            })
            refOrders.queryOrdered(byChild: "orders").observe(.value, with: { snapshot in
                var newOrders: [Order] = []
                for item in snapshot.children {
                    let newOrder = Order(snapshot: item as! DataSnapshot)
                    newOrders.append(newOrder)
                }
                self.storeOrders = newOrders
                self.checkForSegue()
                //                self.tableView.reloadData()
            })
            refPurchase.queryOrdered(byChild: "purchase").observe(.value, with: { snapshot in
                var newPurchases: [Purchases] = []
                for item in snapshot.children {
                    let newPurchase = Purchases(snapshot: item as! DataSnapshot)
                    newPurchases.append(newPurchase)
                }
                self.storePurchases = newPurchases
                self.checkForSegue()
                //                self.tableView.reloadData()
            })
            refStore.queryOrdered(byChild: "store").observe(.value, with: { snapshot in
                var newItems: [Store] = []
                var totalS = 0
                for item in snapshot.children {
                    let newItem = Store(snapshot: item as! DataSnapshot)
                    newItems.append(newItem)
                    totalS += 1
                }
                //                self.tableView.beginUpdates()
                self.storeItems = newItems
                self.inventoryCount = totalS
                //                self.tableView.reloadData()
                self.checkForSegue()

                //                self.tableView.endUpdates()
            })
        })

        
    }
    // CHECK FOR ALL DATABASES LOADED
    func checkForSegue () {
        allLoaded += 1
        if allLoaded > 6 {
            if vendorSigninID != "" {
                performSegue(withIdentifier: "VendorHomeSegue", sender: self)
            } else {
                if buyerSigninID != "" {
                    performSegue(withIdentifier: "VendorHomeSegue", sender: self)
                } else {
                    getBuyerOrVendor()
//                    if buyerLogin {
//                        performSegue(withIdentifier: "VendorHomeSegue", sender: self)
//                    } else {
//                        performSegue(withIdentifier: "VendorHomeSegue", sender: self)
//                    }
                }
            }
        }
    }
    // prompt for buyer/seller registration
    func getBuyerOrVendor () {
        buyerLogin = true
        let alert = UIAlertController(title: "Registering", message: "Are you registering just as a vendor?", preferredStyle: .alert)
        let buyerAction = UIAlertAction(title: "Buyer", style: .default) { action in
            self.buyerLogin = true
            self.performSegue(withIdentifier: "RegisterSegue", sender: self)
        }
        let vendorAction = UIAlertAction(title: "Vendor", style: .default) { action in
            self.buyerLogin = false
            self.performSegue(withIdentifier: "VendorHomeSegue", sender: self)
        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        alert.addAction(cancelAction)
        alert.addAction(buyerAction)
        alert.addAction(vendorAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
            
        case "VendorHomeSegue"?:
            let VendorMain = segue.destination as! VendorHomeVC
            VendorMain.userEmail = userEmail
            VendorMain.storeItems = storeItems
            VendorMain.storeBuyers = storeBuyers
            VendorMain.storePurchases = storePurchases
            VendorMain.storeVendors = storeVendors
            VendorMain.storeOrders = storeOrders
            VendorMain.allDatabaseIDs = allDatabaseIDs
            VendorMain.imagesDict = imagesDict
            VendorMain.inventoryCount = inventoryCount
            break
        case "BuyerHomeSegue"?:
//            let VendorMain = segue.destination as! BuyerHomeVC
//            VendorMain.userEmail = userEmail
//            VendorMain.storeItems = storeItems
//            VendorMain.storeBuyers = storeBuyers
//            VendorMain.storePurchases = storePurchases
//            VendorMain.storeVendors = storeVendors
//            VendorMain.storeOrders = storeOrders
//            VendorMain.allDatabaseIDs = allDatabaseIDs
//            VendorMain.imagesDict = imagesDict
//            VendorMain.inventoryCount = inventoryCount
            break
        case "BuyerSetupSegue"?:

//            let VendorMain = segue.destination as! BuyerHomeVC
//            VendorMain.buyerLogin = buyerLogin
//            VendorMain.userEmail = userEmail
//            VendorMain.storeBuyers = storeBuyers
//            VendorMain.allDatabaseIDs = allDatabaseIDs
//            VendorMain.imagesDict = imagesDict
//            VendorMain.inventoryCount = inventoryCount
            break
        case "VendorSetupSegue"?:
            
//            let VendorMain = segue.destination as! BuyerHomeVC
//            VendorMain.buyerLogin = buyerLogin
//            VendorMain.userEmail = userEmail
//            VendorMain.storeVendors = storeVendors
//            VendorMain.allDatabaseIDs = allDatabaseIDs
//            VendorMain.imagesDict = imagesDict
//            VendorMain.inventoryCount = inventoryCount
            break
        default:
            break
        }

    }
    
    func getImages() {
        // init list of images
        imagesDict["americaXB1Controller.jpg"] = UIImage(named:  "americaXB1Controller.jpg")!
        imagesDict["asusMouse.jpg"] = UIImage(named:  "asusMouse.jpg")!
        imagesDict["gamingglove.jpg"] = UIImage(named:  "gamingglove.jpg")!
        imagesDict["msiMechKeyboard.jpg"] = UIImage(named:  "msiMechKeyboard.jpg")!
        imagesDict["n64Controller.jpeg"] = UIImage(named: "n64Controller.jpeg")!
        imagesDict["ps4ControllerRed.jpg"] = UIImage(named: "ps4ControllerRed.jpg")!
        imagesDict["razrMouse.jpeg"] = UIImage(named:  "razrMouse.jpeg")!
        imagesDict["arcade.jpg"] = UIImage(named:  "arcade.jpg")!
        imagesDict["atari.jpg"] = UIImage(named:  "atari.jpg")!
        imagesDict["gameBoy.jpeg"] = UIImage(named:  "gameBoy.jpeg")!
        imagesDict["gameBoy.jpeg"] = UIImage(named:  "gameBoy.jpeg")!
        imagesDict["nintendo.jpg"] = UIImage(named:  "nintendo.jpg")!
        imagesDict["ps1WithController.jpg"] = UIImage(named:  "ps1WithController.jpg")!
        imagesDict["retron.jpg"] = UIImage(named:  "retron.jpg")!
        imagesDict["xbox1.jpg"] = UIImage(named:  "xbox1.jpg")!
        imagesDict["assassinsCreedOrigins.jpeg"] = UIImage(named:  "assassinsCreedOrigins.jpeg")!
        imagesDict["asteroids.jpg"] = UIImage(named:  "asteroids.jpg")!
        imagesDict["bryGBPokCart.jpg"] = UIImage(named:  "bryGBPokCart.jpg")!  //
        imagesDict["cartCollection.jpg"] = UIImage(named:  "cartCollection.jpg")!
        imagesDict["chopperCommand.jpg"] = UIImage(named:  "chopperCommand.jpg")!
        imagesDict["gameBoyCollectCart.jpg"] = UIImage(named:  "gameBoyCollectCart.jpg")!
        imagesDict["haloConceptCart.jpg"] = UIImage(named:  "haloConceptCart.jpg")!
        imagesDict["hockey.jpg"] = UIImage(named:  "hockey.jpg")!
        imagesDict["rotj.jpg"] = UIImage(named:  "rotj.jpg")!
        imagesDict["segaMegaDrive.jpg"] = UIImage(named:  "segaMegaDrive.jpg")!
        imagesDict["skateIceCart.jpeg"] = UIImage(named:  "skateIceCart.jpeg")!
        imagesDict["starocean.jpg"] = UIImage(named:  "starocean.jpg")!
        imagesDict["tetrisGBCart.jpg"] = UIImage(named:  "tetrisGBCart.jpg")!
            imagesDict["atariBaseBallT.jpg"] = UIImage(named:  "atariBaseBallT.jpg")!
        imagesDict["BASICt.jpg"] = UIImage(named:  "BASICt.jpg")!
        imagesDict["berserkT.jpg"] = UIImage(named:  "berserkT.jpg")!
        imagesDict["evoT.jpg"] = UIImage(named:  "evoT.jpg")!
        imagesDict["gbTShirt.jpg"] = UIImage(named:  "gbTShirt.jpg")!
        imagesDict["gLifeT.jpg"] = UIImage(named:  "gLifeT.jpg")!
        imagesDict["mkTshirt.jpg"] = UIImage(named:  "mkTshirt.jpg")!
        imagesDict["playOnT.jpg"] = UIImage(named:  "playOnT.jpg")!
        imagesDict["retroTSet.jpg"] = UIImage(named:  "retroTSet.jpg")!
        imagesDict["streetFighterT.jpg"] = UIImage(named:  "streetFighterT.jpg")!
    }

}
