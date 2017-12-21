//
//  DataService.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 6/17/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

//references the root of our firebase database
let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    //creates a global var
    static let ds = DataService()
    
    //DB references
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")

    //Storage references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    private var _REF_PROFILE_IMAGES = STORAGE_BASE.child("profile-pics")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }

    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }

    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    var REF_PROFILE_IMAGES: FIRStorageReference {
        return _REF_PROFILE_IMAGES
    }
    
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
}