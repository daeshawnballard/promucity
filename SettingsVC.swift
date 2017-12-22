//
//  SettingsVC.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 6/14/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase


class SettingsVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initializing image picker and allowing editing
        profilePhotoImagePicker = UIImagePickerController()
        profilePhotoImagePicker.allowsEditing = true
        profilePhotoImagePicker.delegate = self
        
    }
   
    //once an image is picked, dismiss the image picker view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let profilePhoto = info[UIImagePickerControllerEditedImage] as? UIImage {
            profilePhotoImg.image = profilePhoto
            profilePhotoSelected = true
        } else {
            print("a valid image wasn't seleteced")
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
        let keychainResults: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Data removed from keychain \(keychainResults)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "logOut", sender: nil)
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
