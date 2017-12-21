//
//  PostsVC.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 3/18/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

import UIKit
import Firebase

class PostsVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //post view textfields
    @IBOutlet weak var artistField: UITextField!
    @IBOutlet weak var captionField: UITextView!
    @IBOutlet weak var venueField: UITextField!
    @IBOutlet weak var citystateField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var postPhotoImg: UIImageView!
    
    
    // Switch between textfields and hide keyboard. Set IBOutlets, delegates and this function.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == artistField{
            captionField.becomeFirstResponder()
        } else if textField == captionField{
            venueField.becomeFirstResponder()
        } else if textField == venueField{
            citystateField.becomeFirstResponder()
        } else if textField == citystateField{
            dateField.becomeFirstResponder()
        } else if textField == dateField{
            timeField.becomeFirstResponder()
        } else {
            timeField.resignFirstResponder()
        }
        return true
    }
    
 
    
    //declaring variables
    var imagePicker: UIImagePickerController!
    var photoSelected = false
    var postedByRef: FIRDatabaseReference!
    var usersPostsRef: FIRDatabaseReference!
    let currentUser = FIRAuth.auth()?.currentUser?.uid
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //initializing image picker and allowing editing
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
    
        
        usersPostsRef = DataService.ds.REF_USER_CURRENT.child("usersPosts")
        
       // print(DataService.ds.REF_USER_CURRENT.child("likes").getKey())
        print(usersPostsRef)
        print(postedByRef)

      
    }
    
    
    //once an image is picked, dismiss the image picker view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            postPhotoImg.image = image
            photoSelected = true
        } else {
            print("a valid image wasn't seleteced")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    //Tap to add image
    @IBAction func tapToAddImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        
    }

    //Posting a post, telling a user they need to enter x stuff
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("caption must be entered")
            return
        }
        //telling a user they need to enter an artist
        guard let artist = artistField.text, artist != "" else {
            print("artist name must be entered")
            return
        }
        //telling a user they need to enter an artist
        guard let venue = venueField.text, venue != "" else {
            print("a venue must be entered")
            return
        }
        //telling a user they need to enter an artist
        guard let city = citystateField.text, city != "" else {
            print("a city must be entered")
            return
        }
        //telling a user they need to pick a photo
        guard let postedPhoto = postPhotoImg.image, photoSelected == true else {
            print("An image must be selected")
            return
        }
        
        
//        usersPostsRef.setValue(true)
//        postedByRef.setValue(true)
        
        //uploading the image to firebase, adding metadata and compressing it
        if let postedPhotoData = UIImageJPEGRepresentation(postedPhoto, 0.2) {
            let postedPhotoUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            
            DataService.ds.REF_POST_IMAGES.child(postedPhotoUid).put(postedPhotoData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("Unable to upload image to Firebase storage")
                } else {
                    print("Upload Successful")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imageUrl: url)
                       
                    }
                }
            }
        }
    }
    
    
 
    
    //formatting the post when posting to firebase and getting ready for a new one
    func postToFirebase(imageUrl: String) {
        let post: Dictionary<String, AnyObject> = [
            "caption": captionField.text! as AnyObject,
            "imageUrl": imageUrl as AnyObject,
            "likes": 0 as AnyObject,
            "artist": artistField.text! as AnyObject,
            "venue": venueField.text! as AnyObject,
            "city": citystateField.text! as AnyObject,
            "postedBy": currentUser as AnyObject,
        ]
        
        
//        postedByRef = DataService.ds.REF_POSTS.child("postedBy")
//        postedByRef.setValue(true)
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        
        captionField.text = ""
        artistField.text = ""
        venueField.text = ""
        citystateField.text = ""
        dateField.text = ""
        timeField.text = ""
        photoSelected = false
        self.postPhotoImg.image = UIImage(named: "camerapostimg")
        
    }
    

    //Tap to dismiss keyboard
    @IBAction func tapToDismiss(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}
