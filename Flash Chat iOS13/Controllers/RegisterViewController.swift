//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text , let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if let e = error{   // if it catches error report
                    print(e.localizedDescription)  // gives errors in the native language of the user
                    self.errorLabel.text = e.localizedDescription
                }
                else {
                    // perform segue to chat window
                    self.performSegue(withIdentifier: k.registerSegue, sender: self)
                }
            }
        }
    }
    
}

// To do list
/* add a pop up message saying password error
 password requirements by firebase*/
// comment
