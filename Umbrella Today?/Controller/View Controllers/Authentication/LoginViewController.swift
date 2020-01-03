//
//  LoginViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 1/2/20.
//  Copyright © 2020 Fiesta Togo Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        emailTextField.delegate = self
        emailTextField.tag = 0
        passwordTextField.delegate = self
        passwordTextField.tag = 1
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    func setupUI() {
        Helpers.styleTextField(emailTextField)
        Helpers.styleTextField(passwordTextField)
        Helpers.styleFilledButton(loginButton)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validate the Fields
        let error = Helpers.validateFields(email: email,
                                           password: password)
        
        if error != nil {
            // There was an error. Show error message
            Helpers.showError(error!, errorLabel: errorLabel)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                Helpers.showError(error!.localizedDescription, errorLabel: self.errorLabel)
                return
            }
            
            self.transitionToHome()
        }
    }
    
    func transitionToHome() {
        dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            // password textfield
            loginButtonTapped("Enter on textfield")
            textField.resignFirstResponder()
            return true
        }
        
       // Try to find next responder
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
          nextField.becomeFirstResponder()
       } else {
          // Not found, so remove keyboard.
          textField.resignFirstResponder()
       }
       // Do not add a line break
       return false
    }
}



