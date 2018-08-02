//
//  Notifications.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 5/29/18.
//  Copyright © 2018 imdaeshawn. All rights reserved.
//

import Foundation
import Firebase

class appNotifications {
    //setting the variables for the notificationsVC
    private var _notifProfileImg: String!
    private var _notifDisplayName: String!
    private var _notifTime: String!
    private var _usersKey: String!
    private var _usersRef: DatabaseReference!
    
    
    var notifProfileImg: String {
        return _notifProfileImg
    }
    
    var notifDisplayName: String {
        return _notifDisplayName
    }
    
    var notifTime: String {
        return _notifTime
    }
    
    var usersKey: String {
        return _usersKey
    }
    
    
    init(notifProfileImg: String, notifDisplayName: String, notifTime: String) {
        self._notifProfileImg = notifProfileImg
        self._notifDisplayName = notifDisplayName
        self._notifTime = notifTime
        
    }
    
    
    init (usersKey: String, usersData: Dictionary<String, AnyObject>){
        self._usersKey = usersKey
        
        if let notifProfileImg = usersData["notifProfileImg"] as? String{
            self._notifProfileImg = notifProfileImg
        }
        
        if let notifDisplayName = usersData["notifDisplayName"] as? String{
            self._notifDisplayName = notifDisplayName
        }
        
        if let notifTime = usersData["notifTime"] as? String{
            self._notifTime = notifTime
        }
  
     _usersRef = DataService.ds.REF_USERS.child(_usersKey)
    }
}


