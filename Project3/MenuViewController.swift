//
//  MenuViewController.swift
//  Project3
//
//  Created by Shane Bersiek on 11/7/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    
    //MARK: example Properties
    var menuNameArray = ["home", "message", "Settings"]
    var menuImageArray = [#imageLiteral(resourceName: "home (2)"), #imageLiteral(resourceName: "message"), #imageLiteral(resourceName: "setting"),]
    
    //MARK: firebase properties
    var databaseRef = Database.database().reference()
    var storage = Storage.storage().reference()
    let tempImageref = Storage.storage().reference().child("tmpDir/tmpImage.jpeg")
    
    @IBOutlet weak var imgProfile: UIImageView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileImg()
       addProfileFromDataBase()
        
       
    }
    
    
    func addProfileFromDataBase() {
        
        tempImageref.getData(maxSize: 1 * 2000 * 2000, completion: { (data, error) in
            
           
            
            if error == nil {
                print("IT WORKED \(data!)")
                
                self.imgProfile.image = UIImage(data: data!)
            }
            else {
                print("IT DIDNT WORK \(error)")
            }
        })
    }
    
    
    
    @IBAction func logoutTouched(_ sender: UIButton) {
        print("logout touched")
        dismiss(animated: true, completion: nil)
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Goodbye!")
        } catch let signOutError as Error {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    func setupProfileImg() {
        imgProfile.layer.borderColor = UIColor.purple.cgColor
        imgProfile.layer.borderWidth = 2
        imgProfile.layer.cornerRadius = 45
        imgProfile.layer.masksToBounds = false
        imgProfile.clipsToBounds = true
        imgProfile.isUserInteractionEnabled = true
        imgProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
    }

    
   
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuNameArray.count
    }
    
    
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
        
        cell.labelMenu.text = menuNameArray[indexPath.row]
        cell.imageIcon.image = menuImageArray[indexPath.row]
        // Configure the cell...
        
        return cell
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
