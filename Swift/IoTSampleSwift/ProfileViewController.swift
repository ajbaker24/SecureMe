//
//  SignUpViewController.swift
//  IoTSampleSwift
//
//  Created by Alex Baker on 11/14/22.
//  Copyright © 2022 Amazon. All rights reserved.
//
import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController{

    @IBOutlet weak var username: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        if let user = user {
        let userEmailString = user.email
            print(userEmailString!)
            username.text = user.email!
        }

    }

    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        //try sign out. if it works go to sign in page
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        _ = navigationController?.popToRootViewController(animated: true)

    }

}
