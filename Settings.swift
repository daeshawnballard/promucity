//
//  Profile.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 7/12/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

//FINSISH SETTING UP THIS DATA MODEL AND SEE IF IT WORKS - DONE, it works!

import Foundation
import Firebase

class Settings {
    //setting the vars for Settings
    private var _profileImgURL: String!
    private var _displayName: String!
    private var _location: String!
    private var _bio: String!
    private var _websiteURL: String!
    private var _facebookURL: String!
    private var _instagramURL: String!
    private var _twitterURL: String!
    private var _usersKey: String!
    private var _usersRef: DatabaseReference!
    

    var profileImgUrl: String {
        return _profileImgURL
    }
    
    var displayName: String {
        return _displayName
    }
    
    var location: String {
        return _location
    }
    
    var bio: String {
        return _bio
    }

    var websiteURL: String {
        return _websiteURL
    }

    var facebookURL: String {
        return _facebookURL
    }
    
    var instagramURL: String {
        return _instagramURL
    }

    var twitterURL: String {
        return _twitterURL
    }

    var usersKey: String {
        return _usersKey
    }


    init(profileImgURL: String, displayName: String, location: String, bio: String, websiteURL: String, facebookURL: String, instagram: String, twitter: String) {
        self._profileImgURL = profileImgURL
        self._displayName = displayName
        self._location = location
        self._bio = bio
        self._websiteURL = websiteURL
        self._facebookURL = facebookURL
        self._instagramURL = instagramURL
        self._twitterURL = twitterURL
    }

    init (usersKey: String, usersData: Dictionary<String, AnyObject>){
        self._usersKey = usersKey
        
        if let profileImgURL = usersData["profileImgURL"] as? String{
            self._profileImgURL = profileImgURL
        }
        
        if let displayName = usersData["displayName"] as? String{
            self._displayName = displayName 
        }
        
        if let location = usersData["location"] as? String{
        self._location = location
        }
        
        if let bio = usersData["bio"] as? String{
        self._bio = bio
        }
        
        if let websiteURL = usersData["website"] as? String{
        self._websiteURL = websiteURL
        }
        
        if let facebookURL = usersData["facebook"] as? String{
        self._facebookURL = facebookURL
        }
        
        if let instagramURL = usersData["instagram"] as? String{
        self._instagramURL = instagramURL
        }
        
        if let twitterURL = usersData["twitter"] as? String{
        self._twitterURL = twitterURL
        }
        _usersRef = DataService.ds.REF_USERS.child(_usersKey)
    }




}
