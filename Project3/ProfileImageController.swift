//
//  ProfileImageController.swift
//  Project3
//
//  Created by Shane Bersiek on 11/7/17.
//  Copyright © 2017 Sean Bukich. All rights reserved.
//


import UIKit
import PhotosUI
import Photos
import Firebase
import FirebaseStorage
import FirebaseDatabase

extension MenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
   
    @objc func handleSelectProfileImage() {
        
        checkPermission()
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }


    
//    func uploadImage(_ Image: UIImage, completionBlock: (_ url: String?, _ errorMessage: String) -> Void ){
//        let storage = Storage.storage()
//        let stroageRef = storage.reference()
//    }
    
  
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
       //imgProfile.textInputMode
        checkPermission()
        
        if let editedImageSelected = info["UIImagePickerControllerOriginalImage"] as? UIImage  {

            
            ///MARK: how to add image to storage
            let image = editedImageSelected
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"

            tempImageref.putData(UIImageJPEGRepresentation(image, 0.8)!, metadata: metaData, completion: { (data, error) in

                if error == nil {
                    print("upload succesful")
                    
                }
                else {
                    print("error")
                }

            })
         
            imgProfile.image = image
            
            }
        
         dismiss(animated: true, completion: nil)
    }
   
   
    
    
   @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancled picker")
        dismiss(animated: true, completion: nil)
    }
}

