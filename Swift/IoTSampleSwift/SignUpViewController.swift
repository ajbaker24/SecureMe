//
//  SignUpViewController.swift
//  IoTSampleSwift
//
//  Created by Alex Baker on 11/14/22.
//  Copyright © 2022 Amazon. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController{
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
   // override func viewWillAppear(_ animated: Bool) {
    //    super.viewWillAppear(animated)
    //}
    
    //    func populateTabBar(){
    //        let tabBarViewController = tabBarController as! IoTSampleTabBarController
    //        tabBarViewController.viewControllers = [self, connectionViewController, subscribeViewController]
    //    }
        
        //https://www.appsdeveloperblog.com/how-to-show-an-alert-in-swift/
        func invalidPasswordAlert(){
            let alertMessage = UIAlertController(title: "Confirm", message: "Invalid. Must be at least 6 characters.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in print("Ok button tapped")})
            alertMessage.addAction(ok)
            self.present(alertMessage, animated: true, completion: nil)
        }

        //https://www.appsdeveloperblog.com/how-to-show-an-alert-in-swift/
        func invalidEmailAlert(){
            let alertMessage = UIAlertController(title: "Confirm", message: "Invalid email. Please use valid email.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in print("Ok button tapped")})
            alertMessage.addAction(ok)
            self.present(alertMessage, animated: true, completion: nil)
        }

        //https://www.appsdeveloperblog.com/how-to-show-an-alert-in-swift/
        func emailInUseAlert(){
            let alertMessage = UIAlertController(title: "Confirm", message: "Email already in use. Please try again.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in print("Ok button tapped")})
            alertMessage.addAction(ok)
            self.present(alertMessage, animated: true, completion: nil)
        }

        //https://www.appsdeveloperblog.com/how-to-show-an-alert-in-swift/
        func wrongPasswordAlert(){
            let alertMessage = UIAlertController(title: "Confirm", message: "Password incorrect. Please try again.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in print("Ok button tapped")})
            alertMessage.addAction(ok)
            self.present(alertMessage, animated: true, completion: nil)
        }

    
    @IBAction func createUser(_ sender: Any) {
        //get inputs
        let email = emailText.text
        let password = passwordText.text
        //clear input fields
        emailText.text = ""
        passwordText.text = ""
                //check proper email
                if (!isValidEmail(email!)){
                    invalidEmailAlert()
                    return
                }
                //check password long enough
                if (!isValidPassword(password!)){
                    invalidPasswordAlert()
                    return
                }
                //tries to add user to firebase
                Auth.auth().createUser(withEmail: email!, password: password!) { [self] authResult, error in
                  if let error = error as? NSError {
                      switch AuthErrorCode.Code.init(rawValue: error.code) {
                    case .emailAlreadyInUse:
                          self.emailInUseAlert()
                    case .invalidEmail:
                          self.invalidEmailAlert()
                    case .weakPassword:
                          self.invalidPasswordAlert()
                    default:
                        print("Error: \(error.localizedDescription)")
                    }
                  } else {
                    print("User signs up successfully")
                      //if successful go to connection view controller
                      self.performSegue(withIdentifier: "goToApp", sender: nil)
                  }
                }
            }

            //sign in func has same code body as sign up
            @IBAction func signIn(_ sender: Any) {
                let email = emailText.text
                let password = passwordText.text
                emailText.text = ""
                passwordText.text = ""
                if (!isValidEmail(email!)){
                    invalidEmailAlert()
                    return
                }
                Auth.auth().signIn(withEmail: email!, password: password!) { (authResult, error) in
                  if let error = error as? NSError {
                      switch AuthErrorCode.Code.init(rawValue: error.code) {
                    case .wrongPassword:
                          self.wrongPasswordAlert()
                    case .invalidEmail:
                          self.invalidEmailAlert()
                    default:
                          print("Error: \(error.localizedDescription)")
                          let alertMessage = UIAlertController(title: "Confirm", message: "Email not found. Please try again.", preferredStyle: .alert)
                          let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in print("Ok button tapped")})
                          alertMessage.addAction(ok)
                          self.present(alertMessage, animated: true, completion: nil)
                    }
                  } else {
                      self.performSegue(withIdentifier: "goToApp", sender: nil)
                  }
                }
                //self.emailNotFoundAlert()
            }

            //Helper methods from https://gist.github.com/myrickchow32/5f559efb44d32aacf4482609162050f7#file-textutils-swift
            
            //checks email is in (String of letters and numbers)@(String of letters and number).(String of letters)
            //example: example123@frog123.com
            func isValidEmail(_ email: String) -> Bool {
              let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
              let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
              return emailPred.evaluate(with: email)
            }
            
            //checks password 6 characteres or longer
            func isValidPassword(_ password: String) -> Bool {
              let minPasswordLength = 6
              return password.count >= minPasswordLength
            }
        }
