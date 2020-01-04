//
//  SignUpViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 1/2/20.
//  Copyright © 2020 Fiesta Togo Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
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

// MARK: - Setup Functions
extension SignUpViewController {
    func setupTextFields() {
        firstNameTextField.autocapitalizationType = UITextAutocapitalizationType.words
        lastNameTextField.autocapitalizationType = UITextAutocapitalizationType.words
        firstNameTextField.delegate = self
        firstNameTextField.tag = 0
        lastNameTextField.delegate = self
        lastNameTextField.tag = 1
        emailTextField.delegate = self
        emailTextField.tag = 2
        passwordTextField.delegate = self
        passwordTextField.tag = 3
    }
    
    func setupUI() {
        Helpers.styleTextField(firstNameTextField)
        Helpers.styleTextField(lastNameTextField)
        Helpers.styleTextField(emailTextField)
        Helpers.styleTextField(passwordTextField)
        Helpers.styleFilledButton(signupButton)
    }
}


// MARK: - IBActions & Objc Functions
extension SignUpViewController {
    @IBAction func signupButtonTapped(_ sender: Any) {
        // dismisses keyboard
        view.endEditing(true)
        
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validate the Fields
        let error = Helpers.validateFields(firstName: firstName,
                                           lastName: lastName,
                                           email: email,
                                           password: password)
        
        if error != nil {
            // There was an error. Show error message
            Helpers.showError(error!, errorLabel: self.errorLabel)
            return
        }
        
        // Create the user
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error!.localizedDescription)
                Helpers.showError("Error creating user.", errorLabel: self.errorLabel)
                return
            } else {
                // User was created successfully, now store the first and last name
                let db = Firestore.firestore()
                
                db.collection("users").addDocument(data: ["first_name": firstName, "last_name": lastName, "uid": result!.user.uid]) { error in
                    
                    if error != nil {
                        print(error!.localizedDescription)
                        Helpers.showError("Error: User data could not be saved on the database.", errorLabel: self.errorLabel)
                        return
                    }
                    
                }
            }
        }
        
//        print("sign up successful!")
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate Methods
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Makes enter button go to next textfield
        
        if textField.tag == 3 {
            // password textfield - enter should be same as pressing sign up
            signupButtonTapped("Enter on textfield")
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
