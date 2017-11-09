//
//  StrawHatDataClasses.swift
//  StrawHatLogIn
//
//  Created by Robert Whitehead on 11/5/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//

import UIKit
import Foundation
import Firebase


// generate new IDs
class generateNewID {
    var key: String
    var buyer: Int
    var vendor: Int
    var purchase: Int
    var order: Int
    var store: Int
    let ref: DatabaseReference?
    
    init(buyer: Int, vendor: Int, purchase: Int, order: Int, store: Int) {
        self.key = "IDs"
        self.buyer = buyer
        self.vendor = vendor
        self.purchase = purchase
        self.order = order
        self.store = store
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        buyer = snapshotValue["buyer"] as! Int
        vendor = snapshotValue["vendor"] as! Int
        purchase = snapshotValue["purchase"] as! Int
        order = snapshotValue["order"] as! Int
        store = snapshotValue["store"] as! Int
        ref = snapshot.ref
    }
    private func getSelf() -> generateNewID {
        return generateNewID(buyer: buyer, vendor: vendor, purchase: purchase, order: order, store: store)
    }
    
    func toAnyObject() -> Any {
        return [
            "buyer": buyer,
            "vendor": vendor,
            "purchase": purchase,
            "order": order,
            "store": store
        ]
    }
    
    func nextBuyerID() -> Int {
        buyer += 1
        updateIDs()
        return buyer
    }
    func nextVendorID() -> Int {
        vendor += 1
        updateIDs()
        return vendor
    }
    func nextPurchaseID() -> Int {
        purchase += 1
        updateIDs()
        return purchase
    }
    func nextOrderID() -> Int {
        order += 1
        updateIDs()
        return order
    }
    func nextStoreID() -> Int {
        store += 1
        updateIDs()
        return store
    }
    private func updateIDs() {
        //    let ref = Database.database().reference(withPath: "IDs")
        //        let idSelf = getSelf()
        let idsRef = Database.database().reference(withPath: "IDs").child("IDs")
        idsRef.setValue(getSelf().toAnyObject())
    }
}

// sales orders - multiple purchases
class Order {
    
    var key: String
    var purchaseDate: String
    var buyerID: Int
    var tax: Double
    var itemsPrice: Double
    var totalPrice: Double
    var purchaseID: [Int] = []
    var priceOfItem: [Double] = []
    var inventoryID: [Int] = []
    var quantity: [Int] = []
    var shipped: [Bool] = []
    var downloaded: [Bool] = []
    let ref: DatabaseReference?
    
    init(purchaseDate: String, buyerID: Int, tax: Double, itemsPrice: Double, totalPrice: Double, purchaseID: [Int],
         priceOfItem: [Double], inventoryID: [Int], quantity: [Int], shipped: [Bool], downloaded: [Bool]) {
        
        let currentDateFormat = DateFormatter()
        currentDateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.key = String(0)
        self.purchaseDate = currentDateFormat.string(from: Date())
        self.buyerID = buyerID
        self.tax = tax
        self.itemsPrice = itemsPrice
        //        self.totalPrice = totalPrice
        self.totalPrice = itemsPrice + (tax * itemsPrice)
        self.priceOfItem = priceOfItem
        self.purchaseID = purchaseID
        self.inventoryID = inventoryID
        self.quantity = quantity
        self.shipped = shipped
        self.downloaded = downloaded
        let pOfI = priceOfItem
        let q = quantity
        var total = 0.0
        for i in 0 ..< purchaseID.count {
            total = total + (pOfI[i] * Double(q[i]))
        }
        self.itemsPrice = total //itemsPrice
        //        self.totalPrice = totalPrice
        self.totalPrice = itemsPrice + (tax * itemsPrice)
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        purchaseDate = snapshotValue["purchaseDate"] as! String
        buyerID = snapshotValue["buyerID"] as! Int
        tax = snapshotValue["tax"] as! Double
        itemsPrice = snapshotValue["itemsPrice"] as! Double
        totalPrice = snapshotValue["totalPrice"] as! Double
        ref = snapshot.ref
        purchaseID = snapshotValue["purchaseID"] as? [Int] ?? [0]
        priceOfItem = snapshotValue["priceOfItem"] as? [Double] ?? [0.0]
        inventoryID = snapshotValue["inventoryID"] as? [Int] ?? [0]
        quantity = snapshotValue["quantity"] as? [Int] ?? [0]
        shipped = snapshotValue["shipped"] as? [Bool] ?? [false]
        downloaded = snapshotValue["downloaded"] as? [Bool] ?? [false]
    }
    
    func toAnyObject() -> Any {
        return [
            "purchaseDate": purchaseDate,
            "buyerID": buyerID,
            "tax": tax,
            "itemsPrice": itemsPrice,
            "totalPrice": totalPrice,
            "purchaseID": purchaseID,
            "priceOfItem": priceOfItem,
            "inventoryID": inventoryID,
            "quantity": quantity,
            "shipped": shipped,
            "downloaded": downloaded
        ]
    }
}

// store inventory
class Store {
    
    var key: String
    var nameOfProduct: String
    var description: String
    var imageName: String
    var ageRestriction: Int
    var vendorID: Int
    var stockDate: String
    var priceDate: String
    var originalDate: String
    var price: Double
    var quantity: Int
    var shipable: Bool
    var download: Bool
    var tags: String
    var ratings: [Int]
    var ratingsComments: [String]
    var imagesNames: [String]
    let ref: DatabaseReference?
    var currentDateFormat = DateFormatter()
    
    init(nameOfProduct: String, description: String, imageName: String, ageRestriction: Int, vendorID: Int, price: Double, quantity: Int, shipable: Bool, download: Bool, tags: String, ratings: [Int], ratingsComments: [String], imagesNames: [String]) {
        
        currentDateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.key = String(0)
        self.nameOfProduct = nameOfProduct
        self.description = description
        self.imageName = imageName
        self.ageRestriction = ageRestriction
        self.vendorID = vendorID
        self.stockDate = currentDateFormat.string(from: Date())
        self.priceDate = currentDateFormat.string(from: Date())
        self.originalDate = currentDateFormat.string(from: Date())
        self.price = price
        self.quantity = quantity
        self.shipable = shipable
        self.download = download
        self.tags = tags
        self.ratings = ratings
        self.ratingsComments = ratingsComments
        self.imagesNames = imagesNames
        self.ref = nil
    }
    
    func restock(_ stockChange: Int) {
        self.quantity = self.quantity + stockChange
        self.stockDate = currentDateFormat.string(from: Date())
    }
    
    func newPrice(_ priceChange: Double) {
        self.price = priceChange
        self.priceDate = currentDateFormat.string(from: Date())
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        nameOfProduct = snapshotValue["nameOfProduct"] as! String
        description = snapshotValue["description"] as! String
        imageName = snapshotValue["imageName"] as! String
        ageRestriction = snapshotValue["ageRestriction"] as! Int
        vendorID = snapshotValue["vendorID"] as! Int
        stockDate = snapshotValue["stockDate"] as! String
        priceDate = snapshotValue["priceDate"] as! String
        originalDate = snapshotValue["originalDate"] as! String
        ref = snapshot.ref
        price = snapshotValue["price"] as! Double
        quantity = snapshotValue["quantity"] as! Int
        shipable = snapshotValue["shipable"] as! Bool
        download = snapshotValue["download"] as? Bool ?? false
        tags = snapshotValue["tags"] as? String ?? ""
        ratings = snapshotValue["ratings"] as? [Int] ?? [0]
        ratingsComments = snapshotValue["ratingsComments"] as? [String] ?? [""]
        let tStr = imageName
        imagesNames = snapshotValue["imagesNames"] as? [String] ?? [tStr]
    }
    
    func toAnyObject() -> Any {
        return [
            "nameOfProduct": nameOfProduct,
            "description": description,
            "imageName": imageName,
            "ageRestriction": ageRestriction,
            "vendorID": vendorID,
            "stockDate": stockDate,
            "priceDate": priceDate,
            "originalDate": originalDate,
            "price": price,
            "quantity": quantity,
            "shipable": shipable,
            "download": download,
            "tags": tags,
            "ratings": ratings,
            "ratingsComments": ratingsComments,
            "imagesNames": imagesNames
        ]
    }
    
}

// Store purchases
// dictionary [key(purchase ID), value(object with properties)]
class Purchases {
    
    var key: String
    var nameOfProduct: String
    var buyerID: Int
    var orderID: Int
    var inventoryID: Int
    var vendorID: Int
    var purchaseDate: String
    var price: Double
    var quantity: Int
    var shipped: Bool
    var downloaded: Bool
    let ref: DatabaseReference?
    var currentDateFormat = DateFormatter()
    
    init(nameOfProduct: String, orderID: Int, buyerID: Int, inventoryID: Int, vendorID: Int, price: Double, quantity: Int, shipped: Bool, downloaded: Bool) {
        
        currentDateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.key = String(0)
        self.nameOfProduct = nameOfProduct
        self.buyerID = buyerID
        self.orderID = orderID
        self.inventoryID = inventoryID
        self.vendorID = vendorID
        self.purchaseDate = currentDateFormat.string(from: Date())
        self.price = price
        self.quantity = quantity
        self.shipped = shipped
        self.downloaded = downloaded
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        nameOfProduct = snapshotValue["nameOfProduct"] as! String
        orderID = snapshotValue["orderID"] as! Int
        buyerID = snapshotValue["buyerID"] as! Int
        vendorID = snapshotValue["vendorID"] as! Int
        inventoryID = snapshotValue["inventoryID"] as! Int
        purchaseDate = snapshotValue["purchaseDate"] as! String
        ref = snapshot.ref
        price = snapshotValue["price"] as! Double
        quantity = snapshotValue["quantity"] as! Int
        shipped = snapshotValue["shipped"] as! Bool
        downloaded = snapshotValue["downloaded"] as! Bool
    }
    
    func toAnyObject() -> Any {
        return [
            "nameOfProduct": nameOfProduct,
            "buyerID": buyerID,
            "orderID": orderID,
            "inventoryID": inventoryID,
            "vendorID": vendorID,
            "purchaseDate": purchaseDate,
            "price": price,
            "quantity": quantity,
            "shipped": shipped,
            "downloaded": downloaded
        ]
    }
    
}

// Buyer Class
class Buyer {
    
    var key: String
    var active: Bool
    var loginID: String
    var nameFirst: String
    var nameMiddle: String
    var nameLast: String
    var nameSuffix: String
    var nameFull: String
    var addressBillStreet: String
    var addressBillStreet2: String
    var addressBillCity: String
    var addressBillState: String
    var addressBillZip: String
    var addressShipStreet: String
    var addressShipStreet2: String
    var addressShipCity: String
    var addressShipState: String
    var addressShipZip: String
    var email: String
    var phone: String
    var gender: String
    var birth: String
    var dateOnboard: String
    var wishlist: [Int] = []
    var purchases: [Int] = []
    let ref: DatabaseReference?
    var currentDateFormat = DateFormatter()
    
    init(active: Bool, loginID: String, nameFirst: String, nameMiddle: String, nameLast: String, nameSuffix: String, addressBillStreet: String, addressBillStreet2: String, addressBillCity: String, addressBillState: String, addressBillZip: String, addressShipStreet: String, addressShipStreet2: String, addressShipCity: String, addressShipState: String, addressShipZip: String, email: String, phone: String, gender: String, birth: String, wishlist: [Int], purchases: [Int]) {
        
        currentDateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.key = String(0)
        self.nameFirst = nameFirst
        self.nameMiddle = nameMiddle
        self.nameLast = nameLast
        self.nameSuffix = nameSuffix
        self.nameFull = self.nameFirst + self.nameMiddle + self.nameLast + self.nameSuffix
        self.active = active
        self.loginID = loginID
        self.addressBillStreet = addressBillStreet
        self.addressBillStreet2 = addressBillStreet2
        self.addressBillCity = addressBillCity
        self.addressBillState = addressBillState
        self.addressBillZip = addressBillZip
        self.addressShipStreet = addressShipStreet
        self.addressShipStreet2 = addressShipStreet2
        self.addressShipCity = addressShipCity
        self.addressShipState = addressShipState
        self.addressShipZip = addressShipZip
        self.email = email
        self.phone = phone
        self.gender = gender
        self.birth = birth
        self.dateOnboard = currentDateFormat.string(from: Date())
        self.wishlist = wishlist
        self.purchases = purchases
        self.ref = nil
    }
    
    func update(active: Bool, loginID: String, nameFirst: String, nameMiddle: String, nameLast: String, nameSuffix: String, addressBillStreet: String, addressBillStreet2: String, addressBillCity: String, addressBillState: String, addressBillZip: String, addressShipStreet: String, addressShipStreet2: String, addressShipCity: String, addressShipState: String, addressShipZip: String, email: String, phone: String, gender: String, birth: String, wishlist: [Int], purchases: [Int]) {
        
        self.nameFirst = nameFirst
        self.nameMiddle = nameMiddle
        self.nameLast = nameLast
        self.nameSuffix = nameSuffix
        self.nameFull = self.nameFirst + self.nameMiddle + self.nameLast + self.nameSuffix
        self.active = active
        self.loginID = loginID
        self.addressBillStreet = addressBillStreet
        self.addressBillStreet2 = addressBillStreet2
        self.addressBillCity = addressBillCity
        self.addressBillState = addressBillState
        self.addressBillZip = addressBillZip
        self.addressShipStreet = addressShipStreet
        self.addressShipStreet2 = addressShipStreet2
        self.addressShipCity = addressShipCity
        self.addressShipState = addressShipState
        self.addressShipZip = addressShipZip
        self.email = email
        self.phone = phone
        self.gender = gender
        self.birth = birth
        self.wishlist = wishlist
        self.purchases = purchases
        
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        active = snapshotValue["active"] as! Bool
        loginID = snapshotValue["loginID"] as! String
        nameFirst = snapshotValue["nameFirst"] as! String
        nameMiddle = snapshotValue["nameMiddle"] as! String
        nameLast = snapshotValue["nameLast"] as! String
        nameSuffix = snapshotValue["nameSuffix"] as! String
        nameFull = snapshotValue["nameFull"] as! String
        addressBillStreet = snapshotValue["addressBillStreet"] as! String
        addressBillStreet2 = snapshotValue["addressBillStreet2"] as! String
        addressBillCity = snapshotValue["addressBillCity"] as! String
        addressBillState = snapshotValue["addressBillState"] as! String
        addressBillZip = snapshotValue["addressBillZip"] as! String
        addressShipStreet = snapshotValue["addressShipStreet"] as! String
        addressShipStreet2 = snapshotValue["addressShipStreet2"] as! String
        addressShipCity = snapshotValue["addressShipCity"] as! String
        addressShipState = snapshotValue["addressShipState"] as! String
        addressShipZip = snapshotValue["addressShipZip"] as! String
        email = snapshotValue["email"] as! String
        phone = snapshotValue["phone"] as! String
        gender = snapshotValue["gender"] as! String
        birth = snapshotValue["birth"] as! String
        dateOnboard = snapshotValue["dateOnboard"] as! String
        ref = snapshot.ref
        wishlist = snapshotValue["wishlist"] as? [Int] ?? [0]
        purchases = snapshotValue["purchases"] as? [Int] ?? [0]
        
    }
    
    func toAnyObject() -> Any {
        return [
            "active": active,
            "loginID": loginID,
            "nameFirst": nameFirst,
            "nameMiddle": nameMiddle,
            "nameLast": nameLast,
            "nameSuffix": nameSuffix,
            "nameFull": nameFull,
            "addressBillStreet": addressBillStreet,
            "addressBillStreet2": addressBillStreet2,
            "addressBillCity": addressBillCity,
            "addressBillState": addressBillState,
            "addressBillZip": addressBillZip,
            "addressShipStreet": addressShipStreet,
            "addressShipStreet2": addressShipStreet2,
            "addressShipCity": addressShipCity,
            "addressShipState": addressShipState,
            "addressShipZip": addressShipZip,
            "email": email,
            "phone": phone,
            "gender": gender,
            "birth": birth,
            "dateOnboard": dateOnboard,
            "wishlist": wishlist,
            "purchases": purchases
            
        ]
    }
    
}

// Vendor with properties and array

class Vendor {
    
    var key: String
    var active: Bool
    var loginID: String
    var nameOfCompanyID: String
    var nameOfCompany: String
    var nameFirst: String
    var nameMiddle: String
    var nameLast: String
    var nameSuffix: String
    var nameFull: String
    var addressBillStreet: String
    var addressBillStreet2: String
    var addressBillCity: String
    var addressBillState: String
    var addressBillZip: String
    var addressShipStreet: String
    var addressShipStreet2: String
    var addressShipCity: String
    var addressShipState: String
    var addressShipZip: String
    var email: String
    var phone: String
    var rating: Int
    var dateOnboard: String
    var salesPurchases: [Int] = []
    var inventoryIDs: [Int] = []
    let ref: DatabaseReference?
    var currentDateFormat = DateFormatter()
    
    init(active: Bool, loginID: String, nameOfCompanyID: String, nameOfCompany: String, nameFirst: String, nameMiddle: String, nameLast: String, nameSuffix: String, addressBillStreet: String, addressBillStreet2: String, addressBillCity: String, addressBillState: String, addressBillZip: String, addressShipStreet: String, addressShipStreet2: String, addressShipCity: String, addressShipState: String, addressShipZip: String, email: String, phone: String, rating: Int, salesPurchases: [Int], inventoryIDs: [Int]) {
        
        currentDateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.key = String(0)
        self.nameOfCompany = nameOfCompany
        self.nameOfCompanyID = nameOfCompanyID
        self.nameFirst = nameFirst
        self.nameMiddle = nameMiddle
        self.nameLast = nameLast
        self.nameSuffix = nameSuffix
        self.nameFull = self.nameFirst + self.nameMiddle + self.nameLast + self.nameSuffix
        self.active = active
        self.loginID = loginID
        self.addressBillStreet = addressBillStreet
        self.addressBillStreet2 = addressBillStreet2
        self.addressBillCity = addressBillCity
        self.addressBillState = addressBillState
        self.addressBillZip = addressBillZip
        self.addressShipStreet = addressShipStreet
        self.addressShipStreet2 = addressShipStreet2
        self.addressShipCity = addressShipCity
        self.addressShipState = addressShipState
        self.addressShipZip = addressShipZip
        self.email = email
        self.phone = phone
        self.rating = rating
        self.dateOnboard = currentDateFormat.string(from: Date())
        self.salesPurchases = salesPurchases
        self.inventoryIDs = inventoryIDs
        self.ref = nil
        
    }
    
    func update(active: Bool, loginID: String, nameOfCompanyID: String, nameOfCompany: String, nameFirst: String, nameMiddle: String, nameLast: String, nameSuffix: String, addressBillStreet: String, addressBillStreet2: String, addressBillCity: String, addressBillState: String, addressBillZip: String, addressShipStreet: String, addressShipStreet2: String, addressShipCity: String, addressShipState: String, addressShipZip: String, email: String, phone: String, rating: Int, salesPurchases: [Int], inventoryIDs: [Int]) {
        
        self.nameOfCompany = nameOfCompany
        self.nameOfCompanyID = nameOfCompanyID
        self.nameFirst = nameFirst
        self.nameMiddle = nameMiddle
        self.nameLast = nameLast
        self.nameSuffix = nameSuffix
        self.nameFull = self.nameFirst + self.nameMiddle + self.nameLast + self.nameSuffix
        self.active = active
        self.loginID = loginID
        self.addressBillStreet = addressBillStreet
        self.addressBillStreet2 = addressBillStreet2
        self.addressBillCity = addressBillCity
        self.addressBillState = addressBillState
        self.addressBillZip = addressBillZip
        self.addressShipStreet = addressShipStreet
        self.addressShipStreet2 = addressShipStreet2
        self.addressShipCity = addressShipCity
        self.addressShipState = addressShipState
        self.addressShipZip = addressShipZip
        self.email = email
        self.phone = phone
        self.rating = rating
        self.salesPurchases = salesPurchases
        self.inventoryIDs = inventoryIDs
    }
    
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        active = snapshotValue["active"] as! Bool
        loginID = snapshotValue["loginID"] as! String
        nameOfCompanyID = snapshotValue["nameOfCompanyID"] as! String
        nameOfCompany = snapshotValue["nameOfCompany"] as! String
        nameFirst = snapshotValue["nameFirst"] as! String
        nameMiddle = snapshotValue["nameMiddle"] as! String
        nameLast = snapshotValue["nameLast"] as! String
        nameSuffix = snapshotValue["nameSuffix"] as! String
        nameFull = snapshotValue["nameFull"] as! String
        addressBillStreet = snapshotValue["addressBillStreet"] as! String
        addressBillStreet2 = snapshotValue["addressBillStreet2"] as! String
        addressBillCity = snapshotValue["addressBillCity"] as! String
        addressBillState = snapshotValue["addressBillState"] as! String
        addressBillZip = snapshotValue["addressBillZip"] as! String
        addressShipStreet = snapshotValue["addressShipStreet"] as! String
        addressShipStreet2 = snapshotValue["addressShipStreet2"] as! String
        addressShipCity = snapshotValue["addressShipCity"] as! String
        addressShipState = snapshotValue["addressShipState"] as! String
        addressShipZip = snapshotValue["addressShipZip"] as! String
        email = snapshotValue["email"] as! String
        phone = snapshotValue["phone"] as! String
        rating = snapshotValue["rating"] as! Int
        dateOnboard = snapshotValue["dateOnboard"] as! String
        ref = snapshot.ref
        salesPurchases = snapshotValue["salesPurchases"] as? [Int] ?? [0]
        inventoryIDs = snapshotValue["inventoryIDs"] as? [Int] ?? [0]
        
    }
    
    func toAnyObject() -> Any {
        return [
            "active": active,
            "loginID": loginID,
            "nameOfCompanyID": nameOfCompanyID,
            "nameOfCompany": nameOfCompany,
            "nameFirst": nameFirst,
            "nameMiddle": nameMiddle,
            "nameLast": nameLast,
            "nameSuffix": nameSuffix,
            "nameFull": nameFull,
            "addressBillStreet": addressBillStreet,
            "addressBillStreet2": addressBillStreet2,
            "addressBillCity": addressBillCity,
            "addressBillState": addressBillState,
            "addressBillZip": addressBillZip,
            "addressShipStreet": addressShipStreet,
            "addressShipStreet2": addressShipStreet2,
            "addressShipCity": addressShipCity,
            "addressShipState": addressShipState,
            "addressShipZip": addressShipZip,
            "email": email,
            "phone": phone,
            "rating": rating,
            "dateOnboard": dateOnboard,
            "salesPurchases": salesPurchases,
            "inventoryIDs": inventoryIDs
            
        ]
    }
    
}

// list of image names
class ImageList {
    var key: String
    var names: [String]
    let ref: DatabaseReference?
    
    init(names: [String]) {
        self.key = "image-list"
        self.names = names
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        names = snapshotValue["names"] as? [String] ?? ["defaultPhoto.png"]
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "names": names
        ]
    }
}





