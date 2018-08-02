//
//  SettingsVC.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 6/14/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SwiftKeychainWrapper

class SettingsVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var facebookField: UITextField!
    @IBOutlet weak var twitterField: UITextField!
    @IBOutlet weak var instagramField: UITextField!
    @IBOutlet weak var profilePhotoImg: UIImageView!
    
    //declaring variables
    var profilePhotoImagePicker: UIImagePickerController!
    var profilePhotoSelected = false
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    // Switch between textfields and hide keyboard. Set IBOutlets, delegates and this function.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField{
            locationField.becomeFirstResponder()
        } else if textField == locationField{
            bioField.becomeFirstResponder()
        } else if textField == bioField{
            websiteField.becomeFirstResponder()
        } else if textField == websiteField{
            facebookField.becomeFirstResponder()
        } else if textField == facebookField{
            twitterField.becomeFirstResponder()
        } else if textField == twitterField {
            instagramField.becomeFirstResponder()
        } else {
            instagramField.resignFirstResponder()
        }
        return true
    }
    
    
    // this function is loading the firebase data for the user's settings
    func loadSettings (img: UIImage? = nil) {
        DataService.ds.REF_USER_CURRENT.child("settings").observeSingleEvent(of: .value, with: { (fbSnap) in
            if let snapShot = fbSnap.value as? Dictionary<String, AnyObject> {
                self.nameField.text = snapShot["displayName"] as? String
                self.bioField.text = snapShot["bio"] as? String
                self.locationField.text = snapShot["location"] as? String
                self.websiteField.text = snapShot["websiteURL"] as? String
                self.facebookField.text = snapShot["facebookURL"] as? String
                self.twitterField.text = snapShot["twitterURL"] as? String
                self.instagramField.text = snapShot["instagramURL"] as? String
                
                // profilePictureImg
                if img != nil {
                    self.profilePhotoImg.image = img
                } else {
                    let ref = Storage.storage().reference(forURL: (snapShot["profileImgUrl"] as? String)!)
                    ref.getData(maxSize: 2 * 1024 * 1024, completion: {(data, error ) in
                        if error != nil {
                            print("Unable to download image from Firebase storage")
                        } else {
                            print("Image downloaded from Firebase storage")
                            if let imgData = data {
                                if let img = UIImage(data: imgData) {
                                    self.profilePhotoImg.image = img
                                    SettingsVC.imageCache.setObject(img, forKey: snapShot["profileImgUrl"] as! NSString)
                                }
                            }
                        }
                    })
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initializing image picker and allowing editing
        profilePhotoImagePicker = UIImagePickerController()
        profilePhotoImagePicker.allowsEditing = true
        profilePhotoImagePicker.delegate = self
        
        //persisting user's settings data
        loadSettings()
        
        //observer for restoring purchases
        NotificationCenter.default.addObserver(self, selector: #selector(showRestoredAlert), name: NSNotification.Name(IAPServiceRestoreNotification), object: nil)
        
    }
    
    //once an image is picked, dismiss the image picker view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let profilePhoto = info[UIImagePickerControllerEditedImage] as? UIImage {
            profilePhotoImg.image = profilePhoto
            profilePhotoSelected = true
        } else {
            print("a valid image wasn't selected")
        }
        profilePhotoImagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    //Tap to add image
    @IBAction func profileImgTapped(_ sender: Any) {
        present(profilePhotoImagePicker, animated: true, completion: nil)
    }
    
    
    
    ///////// IMAGE STUFF
    
    
    
    //Posting the settings, telling a user they need to enter x stuff
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        //telling a user they need to pick a photo
        guard let profilePhoto = profilePhotoImg.image, profilePhotoSelected == true else {
            print("An image must be selected")
            return
        }
        
        guard let displayName = nameField.text, displayName != "" else {
            print("You must enter a display name")
            return
        }
        
        guard let bio = bioField.text, bio != "" else {
            print("You must enter a bio!")
            return
        }
        
        guard let location = locationField.text, location != "" else {
            print("You must enter a location!")
            return
        }
        
        guard let websiteURL = websiteField.text, websiteURL != "" else {
            print("You must enter a website!")
            return
        }
        
        guard let facebookURL = facebookField.text, facebookURL != "" else  {
            print("You must enter a facebook url!")
            return
        }
        
        guard let instagramURL = instagramField.text, instagramURL != "" else {
            print("You must enter an instagram url!")
            return
        }
        
        guard let twitterURL = twitterField.text, twitterURL != "" else {
            print("You must enter a twitter!")
            return
        }
        
        //self.settingsToFirebase()
        
        
        //uploading the image to firebase, adding metadata and compressing it
        if let profilePhotoData = UIImageJPEGRepresentation(profilePhoto, 0.2) {
            let profilePhotoUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            
            DataService.ds.REF_PROFILE_IMAGES.child(profilePhotoUid).putData(profilePhotoData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("Unable to upload image to Firebase storage")
                } else {
                    print("Upload Successful")
                    let profilePhotoDownloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = profilePhotoDownloadURL {
                        self.settingsToFirebase(profilePhotoImgUrl: url)
                        
                    }
                }
            }
        }
    }
    
    
    
    
    //Posting to firebase
    func settingsToFirebase(profilePhotoImgUrl: String) {
        let settings: Dictionary<String, AnyObject> = [
            "profileImgUrl": profilePhotoImgUrl as AnyObject,
            "displayName": nameField.text! as AnyObject,
            "bio": bioField.text! as AnyObject,
            "location": locationField.text! as AnyObject,
            "websiteURL": websiteField.text! as AnyObject,
            "facebookURL": facebookField.text! as AnyObject,
            "instagramURL": instagramField.text! as AnyObject,
            "twitterURL": twitterField.text! as AnyObject,
            ]
        let firebaseSettings = DataService.ds.REF_USER_CURRENT.child("settings")
        firebaseSettings.setValue(settings)
        
        //        nameField.text = ""
        //        bioField.text = ""
        //        locationField.text = ""
        //        websiteField.text = ""
        //        facebookField.text = ""
        //        instagramField.text = ""
        //        twitterField.text = ""
    }
    
    //sign out function
    @IBAction func logOut(_ sender: Any) {
        //remove keychain credentials
        let keychainResults: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Data removed from keychain \(keychainResults)")
        try! Auth.auth().signOut()
        
        //sign out of google sign on
        let gSignOut = GIDSignIn()
        gSignOut.signOut()
        
        //go back to sign in screen
        performSegue(withIdentifier: "logOut", sender: nil)
    }
    
    //this is to restore any purchases they've made
    @IBAction func restorePurchases(_ sender: Any) {
        let alert = UIAlertController(title:"Restore Purchases?", message: "Do you want to restore any in-app purchases you've previously purcahased?", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Restore", style: .default) { (action) in
            IAPService.instance.restorePurchases()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //showing alert if purchases are restored
    func showRestoredAlert() {
        let alert = UIAlertController(title: "Success!", message: "Your purchases were successfully restored.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //contacting support, need to change to promucity email
    @IBAction func emailSupportTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "mailto:imdaeshawn@gmail.com")!, options:[:], completionHandler: nil)
    }
    
    //tap to dismiss keyboard
    @IBAction func tapToDismiss(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
}
