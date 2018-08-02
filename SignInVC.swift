//
//  SignInVC.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 3/18/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SwiftKeychainWrapper


class SignInVC: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    // Switch between textfields and hide keyboard. Set IBOutlets, delegates and this function.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            passwordField.resignFirstResponder()
        }
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    
    //Logging in with Email and Password
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            let alert = UIAlertController(title: "Username/Password Invalid", message: "Please make sure both your username and password are correct", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title:"OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            print("Unable to authenticate email user with Firebase")
                        } else {
                            print("Successfully autthenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    @IBAction func googleBtnTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    //Authenticating with Firebase
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print(" Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("Successfully authenticated with Firebase")
                //This allows for keychain access, letting a previously signedin user to not have to sign in again
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }    
    
    //if the login is entered correctly, go into the app
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    
    //This performs the segue to the feed if the login has been previously saved
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResults = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Data saved to keychain \(keychainResults)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
        
    }
    
    // tap to dimiss the keyboard
    @IBAction func tapToDimiss(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
}

