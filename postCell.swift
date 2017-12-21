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
    var currentUser = FIRAuth.auth()?.currentUser?.uid
   // var user: Settings!
    var likesRef: FIRDatabaseReference!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization Like Image to act as a button programmactily via a tap guesture recog
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        eventPostLikeImg.addGestureRecognizer(tap)
        eventPostLikeImg.isUserInteractionEnabled = true
        
    }
    
    // this is showing what elements of the post container we will be using/seeing and pulling in data for
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post

        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
       // self.eventPostUserNameLbl.text = "\(DataService.ds.REF_USER_CURRENT.child("settings").child(user.displayName))"
        self.eventPostDesTV.text = post.caption
        self.eventPostPerformerLbl.text = post.artist
        self.eventPostLocationLbl.text = "\(post.venue) - \(post.city)"
        self.eventPostLikeLbl.text = "\(post.likes)"
        
        if img != nil{
            self.eventPostImg.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: {(data, error ) in
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
        
            likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.eventPostLikeImg.image = UIImage(named: "unLikeImg")
            } else {
                self.eventPostLikeImg.image = UIImage(named: "likeImg" )
            }
        })
    }
    
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

