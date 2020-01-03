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

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    
    func setupUI() {
        errorLabel.alpha = 0
        Helpers.styleTextField(firstNameTextField)
        Helpers.styleTextField(lastNameTextField)
        Helpers.styleTextField(emailTextField)
        Helpers.styleTextField(passwordTextField)
        Helpers.styleFilledButton(signupButton)
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
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
            showError(error!)
        }
        
        // Create the user
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error!.localizedDescription)
                self.showError("Error creating user.")
            } else {
                // User was created successfully, now store the first and last name
                let db = Firestore.firestore()
                
                db.collection("users").addDocument(data: ["first_name": firstName, "last_name": lastName, "uid": result!.user.uid]) { error in
                    
                    if error != nil {
                        print(error!.localizedDescription)
                        self.showError("Error: User data could not be saved on the database.")
                    }
                    
                }
            }
        }
        
//        print("sign up successful!")
        // Transition to the Home Screen
        transitionToHome()
    }
    
    func showError(_ errorMessage: String) {
        errorLabel.text = errorMessage
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
//        self.view.window!.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
        dismiss(animated: true, completion: nil)
    }
}
