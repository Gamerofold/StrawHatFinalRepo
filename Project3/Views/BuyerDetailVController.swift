//
//  BuyerDetailVController.swift
//  Project3
//
//  Created by Shane Bersiek on 11/6/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

//refreshes my view
extension UIViewController {
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
}
class BuyerDetailVController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
<<<<<<< HEAD
    
    //MARK: firebase references
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("store")
    private var channelRefHandle: DatabaseHandle?
    
=======
>>>>>>> 6250753d99b974a4fb7a301280079157eca7b903
    //MARK:Properties
    var productDetail = [BuyerProducts]()
    var itemImgArray = [UIImage]()
    
    @IBOutlet weak var ImageScrollView: UIScrollView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDescription: UITextView!
    
   
    override func viewWillAppear(_ animated: Bool) {
         observeChannels()
        
   }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemImgArray.append(productDetail[myIndexBuyer].photo)
        itemName.text = productDetail[myIndexBuyer].label
        itemDescription.text = productDetail[myIndexBuyer].description
       
        setScrollViewImages()
       // itemName.text = productDetail[myIndexBuyer].label
       // itemDescription.text = productDetail[myIndexBuyer].description
        
        // Do any additional setup after loading the view.
         
    }
   
    //turns off observer
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviews", for: indexPath)
        
        return cell
    }
    
    
    func setScrollViewImages(){
       // itemImgArray = [#imageLiteral(resourceName: "megaManBox"), #imageLiteral(resourceName: "megaman"), #imageLiteral(resourceName: "megaManBoss")]
        
        
        for i in 0..<itemImgArray.count {
            
            let imageView = UIImageView()
            imageView.image =  itemImgArray[i]
            let xposition = self.view.frame.width * (CGFloat(i) * 0.92)
            imageView.frame = CGRect(x: xposition, y: 0, width: self.ImageScrollView.frame.width, height: self.ImageScrollView.frame.height)
            ImageScrollView.contentSize.width = ImageScrollView.frame.width * (CGFloat(i) + 1.85
            )
            ImageScrollView.addSubview(imageView)
        }
    }
    
    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        
        // 1 You call observe:with: on your channel reference, storing a handle to the reference. This calls the completion block every time a new channel is added to your database.
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            // 2 The completion receives a FIRDataSnapshot (stored in snapshot), which contains the data and other helpful methods.
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            //let id = snapshot.key
            // 3 You pull the data out of the snapshot and, if successful, create a Channel model and add it to your channels array.
           // print("my snapshot \(channelData)")
            if let name = channelData["nameOfProduct"] as! String!, name.characters.count > 0 {
                let myDescription = channelData["description"] as! String!
               let image = channelData["imageName"] as! String!
                print("bukie \(name)")
                
                
                self.productDetail.append(BuyerProducts(photo: UIImage(named: image!)!, label: name, description: myDescription!))
                
                
            } else {
                print("Error! Could not decode channel data")           }
        })
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue pressed")
        
    }
    
    
}
