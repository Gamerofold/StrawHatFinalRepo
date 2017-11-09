//
//  ViewController.swift
//  StrawHatLogIn
//
//  Created by Sean Bukich on 11/3/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {
    
//    var userEmail: String = ""
//    var buyerFlag: Bool = false
//    var vendorFlag: Bool = false
    
    //outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
//        vendorFlag = false
//        buyerFlag = false
        // 1
        Auth.auth().addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // self.userEmail = (user?.email)!
                // 3
                self.performSegue(withIdentifier: "loggedIn", sender: self)
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "loggedIn" {
//
//            //SEGUE FROM A VC to a TAB BAR CONTROLLER
//
//
//            let tabBar = segue.destination as! UITabBarController
//
//            let VendorMain = tabBar.viewControllers![0] as! BrowseTableViewController
//
//            VendorMain.buyerFlag = buyerFlag
//            VendorMain.vendorFlag = vendorFlag
//            VendorMain.userEmail = userEmail
//
//        }
//    }
    
    
    //actions
    @IBAction func loginTouched(_ sender: Any) {
        
//        vendorFlag = false
//        buyerFlag = false
        
        Auth.auth().signIn(withEmail: emailTextField.text!,  password: passwordTextField.text!)
        
        
    }
    
//    @IBAction func signUpSeller(_ sender: Any) {
//        
//        buyerFlag = false
//        vendorFlag = true
//        
//        let alert = UIAlertController(title: "Register as Seller", message: "Please Create an Account", preferredStyle: .alert)
//        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
//            // 1
//            let emailField = alert.textFields![0]
//            let passwordField = alert.textFields![1]
//            
//            // 2
//            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
//                if error == nil {
//                    // 3
//                    Auth.auth().signIn(withEmail: self.emailTextField.text!,password: self.passwordTextField.text!)
//                }
//            }
//        }
//        let cancelAction = UIAlertAction(title: "Cancel",
//                                         style: .default)
//        
//        alert.addTextField { textEmail in
//            textEmail.placeholder = "Enter your email"
//        }
//        
//        alert.addTextField { textPassword in
//            textPassword.isSecureTextEntry = true
//            textPassword.placeholder = "Enter your password"
//        }
//        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true, completion: nil)
//        
//    }
    
    
    
    @IBAction func signupTouched(_ sender: Any) {
        
//        buyerFlag = true
//        vendorFlag = false
        
        let alert = UIAlertController(title: "Register as Buyer", message: "Please Create an Account", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            // 1
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            // 2
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                if error == nil {
                    // 3
                    Auth.auth().signIn(withEmail: self.emailTextField.text!,password: self.passwordTextField.text!)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}


