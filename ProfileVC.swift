//
//  ProfileVC'.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 7/15/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileLocation: UILabel!
    @IBOutlet weak var profileBio: UILabel!
    @IBOutlet weak var profileYoutube: UILabel!
    @IBOutlet weak var profileFacebook: UILabel!
    @IBOutlet weak var profileTwitter: UILabel!
    @IBOutlet weak var profileInstagram: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileBackgroundPhoto: UIImageView!
    @IBOutlet weak var profilePhoto: UIImageView!
    // variables
    
    var settings: Settings!
    var facebookButtonURL: String!
    var websiteButtonURL: String!
    var url: URL!
    let currentUser = FIRAuth.auth()?.currentUser?.uid
    let usersLikes = DataService.ds.REF_USER_CURRENT.child("likes")
    
    //setting the container for the post that will show in the feed
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    //when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfile()
        
        //Tableview stuff
        //delegates
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        
        
    }
    
    // This is allowing the user to see only their liked post on their profile
    @IBAction func likesButtonTapped(_ sender: Any) {
        self.posts.removeAll()
        
        DataService.ds.REF_USER_CURRENT.child("likes").observe(.value, with: { (snapshotlikes) in
            if let snapshotlikes = snapshotlikes.children.allObjects as? [FIRDataSnapshot] {
                for snaps in snapshotlikes {
                    if snaps.key != nil {
                        
                        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
                            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                for snap in snapshot {
                                    print("SNAP: \(snap)")
                                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                        let key = snap.key
                                        let post = Post(postKey: key, postData: postDict)
                                        
                                        if snap.key == snaps.key {
                                            //This stops the tableView from duplicating itself
                                            if !self.posts.contains(where: {$0.postKey == key})
                                            {
                                                self.posts.append(post)
                                            }
                                        }
                                    }
                                }
                            }
                            //updating for new info
                            self.profileTableView.reloadData()
                        })
                    } else {
                        self.posts.removeAll()
                        //alert no favorites..
                    }
                    
                }
            }
        })
    }
    
    
    // This is allowing a user to see only the post that they've made on their profile
    @IBAction func myEventsButtonTapped(_ sender: Any) {
        self.posts.removeAll()
        loadUsersPosts()
    }
    
    // This is allowing a user to see only the post that they've made on their profile
    func loadUsersPosts() {
        
        
        DataService.ds.REF_POSTS.queryOrdered(byChild: "postedBy").queryEqual(toValue: currentUser).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        //This stops the tableView from duplicating itself
                        if !self.posts.contains(where: {$0.postKey == key})
                        {
                            self.posts.append(post)
                        }
                    }
                }
            }
            //updating for new info
            self.profileTableView.reloadData()
            
        })
    }
    
    
    
    // when the view appears
    override func viewDidAppear(_ animated: Bool) {
        updateProfile()
        self.posts.removeAll()
        loadUsersPosts()
    }
    
    
    // this function is listening for the firebase data changes for settings and updating the profile view
    func updateProfile(img: UIImage? = nil, img2: UIImage? = nil) {
        DataService.ds.REF_USER_CURRENT.child("settings").observeSingleEvent(of: .value, with: { (fbSnap) in
            if let snapShot = fbSnap.value as? Dictionary<String, AnyObject> {
                self.profileName.text = snapShot["displayName"] as? String
                self.profileBio.text = snapShot["bio"] as? String
                self.profileLocation.text = snapShot["location"] as? String
                self.profileYoutube.text = snapShot["websiteURL"] as? String
                self.profileFacebook.text = snapShot["facebookURL"] as? String
                self.profileTwitter.text = snapShot["twitterURL"] as? String
                self.profileInstagram.text = snapShot["instagramURL"] as? String
                
//                profilePictureImg
//
                if img != nil {
                    self.profilePhoto.image = img
                } else {
                    let ref = FIRStorage.storage().reference(forURL: (snapShot["profileImgUrl"] as? String)!)
                    ref.data(withMaxSize: 2 * 1024 * 1024, completion: {(data, error ) in
                        if error != nil {
                            print("Unable to download image from Firebase storage")
                        } else {
                            print("Image downloaded from Firebase storage")
                            if let imgData = data {
                                if let img = UIImage(data: imgData) {
                                    self.profilePhoto.image = img
                                    ProfileVC.imageCache.setObject(img, forKey: snapShot["profileImgUrl"] as! NSString)
                                }
                            }
                        }
                    })
                }
                
                if img2 != nil {
                    self.profileBackgroundPhoto.image = img2
                } else {
                    let ref = FIRStorage.storage().reference(forURL: (snapShot["profileImgUrl"] as? String)!)
                    ref.data(withMaxSize: 2 * 1024 * 1024, completion: {(data, error ) in
                        if error != nil {
                            print("Unable to download image from Firebase storage")
                        } else {
                            print("Image downloaded from Firebase storage")
                            if let imgData = data {
                                if let img2 = UIImage(data: imgData) {
                                   self.profileBackgroundPhoto.image = img2
                                    ProfileVC.imageCache.setObject(img2, forKey: snapShot["profileImgUrl"] as! NSString)
                                }
                            }
                        }
                    })
                }
            }
        })
        
    }
    
    // These button have the firebase urls being passed into labels that are then passed into the buttons. The only solution is to have them copy their pages as https is the only thing supported.
    
    @IBAction func gotoYoutubePage(_ sender: Any) {
        UIApplication.shared.open(URL(string: profileYoutube.text!)!, options:[:], completionHandler: nil)
    }
    
    @IBAction func gotoFacebookPage(_ sender: Any) {
        UIApplication.shared.open(URL(string: profileFacebook.text!)!, options:[:], completionHandler: nil)
    }
    @IBAction func gotoTwitterPage(_ sender: Any) {
        UIApplication.shared.open(URL(string: profileTwitter.text!)!, options:[:], completionHandler: nil)
    }
    @IBAction func gotoInstagramPage(_ sender: Any) {
        UIApplication.shared.open(URL(string: profileInstagram.text!)!, options:[:], completionHandler: nil)
    }
    
    
    // User profile feed table view code
    
    func numberOfSections(in profileTableView: UITableView) -> Int {
        //this is returning one column for our feed
        return 1
    }
    
    func tableView(_ profileTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this is saying, however many post there are, show them
        return posts.count
    }
    
    func tableView(_ profileTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //this method is allowing us to put the container "post" into our feed. and caches it
        let post = posts[indexPath.row]
        
        if let cell = profileTableView.dequeueReusableCell(withIdentifier: "postCell") as? postCell {
            
            if let img = EventsVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return postCell()
        }
    }
}








