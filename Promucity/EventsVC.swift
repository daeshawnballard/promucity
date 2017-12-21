//
//  EventsVC.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 3/18/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class EventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var feedSearchBar: UISearchBar!
    
    //setting the container for the post that will show in the feed
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegates
        tableView.delegate = self
        tableView.dataSource = self
        //feedSearchBar.delegate = self
        
        
        //need to add search bar funtionality
        
        
        loadFeed()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.posts.removeAll()
        loadFeed()
        
    }
    
    
    
    func loadFeed(){
        //this service is pulling from the feed data model in firebase constantly
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
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
            self.tableView.reloadData()
        })

        
    }
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //this is returning one column for our feed
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this is saying, however many post there are, show them
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //this method is allowing us to put the container "post" into our feed. and caches it
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? postCell {
            
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
    
    //searchbar stuff
    
    
}

