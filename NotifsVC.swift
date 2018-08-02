//
//  NotifsVC.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 6/5/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

import UIKit

class NotifsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //declaring variables
//    var notifsUserName = ""
//    var notifsProfilePhotoUrl = ""
//    
//    func gatherUserDataForNotifs() {
//        
//        //Getting user displayName from settings
//        DataService.ds.REF_USER_CURRENT.child("settings").observeSingleEvent(of: .value, with: { (fbSnap) in
//            if let snapShot = fbSnap.value as? Dictionary<String, AnyObject> {
//                self.notifsUserName = (snapShot["displayName"] as? String)!
//                self.notifsProfilePhotoUrl = (snapShot["profileImgUrl"] as? String)!
//                
//            }
//        })
//    }
    
    //setting the container for the post that will show in the feed
    var notifications = [appNotifications]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        self.posts.removeAll()
//        loadNotifications()
//
//    }
//
    
//
//    func loadNotifications(){
//        //this service is pulling from the feed data model in firebase constantly
//        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
//            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
//                for snap in snapshot {
//                    print("SNAP: \(snap)")
//                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let post = Post(postKey: key, postData: postDict)
//                        //This stops the tableView from duplicating itself
//                        if !self.posts.contains(where: {$0.postKey == key})
//                        {
//                            self.posts.append(post)
//                        }
//                    }
//                }
//            }
//            //updating for new info
//            self.tableView.reloadData()
//        })
//
//
//    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "notifsCell") as! notifsCell
    }
    
    //the cache system for notifs aren't working. Should I name it something different? IS the
    
//    func notifTableViewCache(_ notifTableViewCache: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //this method is allowing us to put the container "post" into our feed. and caches it
//        let notif = notification[indexPath.row]
//
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "notifsCell") as? postCell {
//
//            if let img = NotifsVC.imageCache.object(forKey: notifications.notifProfileImg as NSString), let notifsProfilePhoto = NotifsVC.imageCache.object(forKey: notification
//                .notifsProfilePhotoUrl as NSString) {
//                cell.configureCell(notification: notification, img: img, profileImg: profileImg)
//            } else {
//                cell.configureCell(notification: notification)
//            }
//            return cell
//        } else {
//            return postCell()
//        }
//    }

}
