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

    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        setupTextFields()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
}

// MARK: - Setup
extension LoginViewController {
    func setupUI() {
        Helpers.Style.textField(emailTextField)
        Helpers.Style.textField(passwordTextField)
        Helpers.Style.redButton(loginButton)
    }
    
    func setupTextFields() {
        emailTextField.delegate = self
        emailTextField.tag = 0
        passwordTextField.delegate = self
        passwordTextField.tag = 1
    }
}

// MARK: - IBActions & Objc Functions
extension LoginViewController {
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
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UITextFieldDelegate Methods
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
       }
        
       return false
    }
}



