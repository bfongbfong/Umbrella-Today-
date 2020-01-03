//
//  UserInfoViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 1/3/20.
//  Copyright © 2020 Fiesta Togo Inc. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserInfoViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var nameOfUser: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupUI() {
        errorLabel.alpha = 0
        Helpers.styleFilledButton(logoutButton)

        if let nameOfUser = nameOfUser {
            greetingLabel.text = "Hello,"
            nameLabel.text = nameOfUser
        } else {
            greetingLabel.text = "Hello"
            nameLabel.text = ""
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            Helpers.showError("There was an error logging out. Please restart the app and try again.", errorLabel: errorLabel)
        }
    }
}
