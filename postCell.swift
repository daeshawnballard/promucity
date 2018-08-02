//
//  postCell.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 4/1/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

import UIKit
import Firebase


class postCell: UITableViewCell {

    @IBOutlet weak var eventPostImg: UIImageView!
    @IBOutlet weak var eventPostLocationLbl: UILabel!
    @IBOutlet weak var eventPostDateTimeLbl: UILabel!
    @IBOutlet weak var eventPostPerformerLbl: UILabel!
    @IBOutlet weak var eventPostLikeImg: UIImageView!
    @IBOutlet weak var eventPostLikeLbl: UILabel!
    @IBOutlet weak var eventPostUserProfileImg: UIImageView!
    @IBOutlet weak var eventPostUserNameLbl: UILabel!
    @IBOutlet weak var eventPostDesTV: UITextView!
   
    
    //setting the postcell up, what we will see in the feed
    var post: Post!
    var currentUser = Auth.auth().currentUser?.uid
    var likesRef: DatabaseReference!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization Like Image to act as a button programmactily via a tap guesture recog
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        eventPostLikeImg.addGestureRecognizer(tap)
        eventPostLikeImg.isUserInteractionEnabled = true
        
    }
    
    // this is showing what elements of the post container we will be using/seeing and pulling in data for
    func configureCell(post: Post, img: UIImage? = nil, profileImg: UIImage? = nil) {
        self.post = post

        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.eventPostUserNameLbl.text = post.postedBy
        self.eventPostDesTV.text = post.caption
        self.eventPostPerformerLbl.text = post.artist
        self.eventPostLocationLbl.text = "\(post.venue) - \(post.city)"
        self.eventPostLikeLbl.text = "\(post.likes)"
        
        //setting the user's post image in the post on the feed
        if img != nil{
            self.eventPostImg.image = img
        } else {
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: {(data, error ) in
                if error != nil {
                    print("Unable to download image from Firebase storage")
                } else {
                    print("Image downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.eventPostImg.image = img
                        EventsVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
        //setting the user's profile image in their post on the feed
        if profileImg != nil {
            self.eventPostUserProfileImg.image = profileImg
        } else {
            let profileRef = Storage.storage().reference(forURL: post.profilePhotoUrl)
            profileRef.getData(maxSize: 2 * 1024 * 1024, completion: {(data, error ) in
                if error != nil {
                    print("Unable to download image from Firebase storage")
                } else {
                    print("Image downloaded from Firebase storage")
                    if let profileImgData = data {
                        if let profileImg = UIImage(data: profileImgData) {
                            self.eventPostUserProfileImg.image = profileImg
                            EventsVC.imageCache.setObject(profileImg, forKey: post.profilePhotoUrl as NSString)
                        }
                    }
                }
            })
        }
        
            likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.eventPostLikeImg.image = UIImage(named: "unLikeImg")
            } else {
                self.eventPostLikeImg.image = UIImage(named: "likeImg" )
            }
        })
    }
    
    //executing the like and unlike function
    func likeTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.eventPostLikeImg.image = UIImage(named: "likeImg")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
                
            } else {
                self.eventPostLikeImg.image = UIImage(named: "unLikeImg" )
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }

}

