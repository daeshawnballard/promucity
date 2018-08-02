//
//  notifsCell.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 6/5/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

import UIKit

class notifsCell: UITableViewCell {

    @IBOutlet weak var notifsActionLbl: UILabel!
    @IBOutlet weak var notifsActionTime: UILabel!
    @IBOutlet weak var notifsProfileImg: CircleView!
    @IBOutlet weak var notifsDisplayNameLbl: UILabel!
    @IBOutlet weak var notifsTimeLbl: UILabel!
    
    //setting the notifsCell up, what we will see in the feed
    var notifications: appNotifications!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }
    
    
    
    // this is showing what elements of the post container we will be using/seeing and pulling in data for
    func configureCell(post: Post, notifProfileImg: UIImage? = nil) {
      //  self.notifications = no
        self.notifsDisplayNameLbl.text = post.postedBy
       

        //setting the user's profile image in their post on the feed
//        if profileImg != nil {
//            self.eventPostUserProfileImg.image = profileImg
//        } else {
//            let profileRef = Storage.storage().reference(forURL: post.profilePhotoUrl)
//            profileRef.getData(maxSize: 2 * 1024 * 1024, completion: {(data, error ) in
//                if error != nil {
//                    print("Unable to download image from Firebase storage")
//                } else {
//                    print("Image downloaded from Firebase storage")
//                    if let profileImgData = data {
//                        if let profileImg = UIImage(data: profileImgData) {
//                            self.eventPostUserProfileImg.image = profileImg
//                            EventsVC.imageCache.setObject(profileImg, forKey: post.profilePhotoUrl as NSString)
//                        }
//                    }
//                }
//            })
        }
    

}



