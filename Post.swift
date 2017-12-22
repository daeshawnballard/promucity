//
//  post.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 6/17/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

import Foundation
import Firebase

class Post {

    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: DatabaseReference!
//    private var _usersKey: String!
//    private var _usersRef: FIRDatabaseReference!
    private var _artist: String!
    private var _venue: String!
    private var _postedBy: String!
    private var _usersPosts: String!
    private var _city: String!
//    private var _date: need to add date picker
//    private var _time: need to add date picker
    
    var caption: String {
        return _caption
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var artist: String {
        return _artist
    }
    
    var venue: String {
        return _venue
    }
    
    var city: String {
        return _city
    }
    
    var postKey: String {
        return _postKey
    }

    var postedBy: String {
        return _postedBy
    }

    var usersPosts: String {
        return _usersPosts
    }
    
    init(caption: String, imageUrl: String, likes: Int, artist: String, city: String, venue: String, postedBy: String, usersPosts: String) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
        self._artist = artist
        self._venue = venue
        self._city = city
        self._postedBy = postedBy
        self._usersPosts = usersPosts
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>){
            self._postKey = postKey
        
        if let caption = postData["caption"] as? String{
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String{
            self._imageUrl = imageUrl
        }
        
        if let artist = postData["artist"] as? String{
            self._artist = artist
        }
        
        if let venue = postData["venue"] as? String{
            self._venue = venue
        }
        
        if let city = postData["city"] as? String{
            self._city = city
        }
        
        if let likes = postData["likes"] as? Int{
            self._likes = likes
        }
        
        if let postedBy = postData["postedBy"] as? String{
            self._postedBy = postedBy
        }
  
        if let usersPosts = postData["usersPosts"] as? String{
            self._usersPosts = usersPosts
        }
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
}
