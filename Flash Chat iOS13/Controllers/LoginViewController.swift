//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text{
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
               
                if let e = error {  // error in login 
                    print(e.localizedDescription)
                } else {
                    // perform the segue to the chat window
                    self?.performSegue(withIdentifier: k.loginSegue, sender: self)
                }
            }
        }
    }
}


// welcome back message after succesfull login
// comment
