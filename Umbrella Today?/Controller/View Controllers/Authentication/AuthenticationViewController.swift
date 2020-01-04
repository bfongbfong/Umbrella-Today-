//
//  AuthenticationViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 1/2/20.
//  Copyright © 2020 Fiesta Togo Inc. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Need these here because there is no navigation bar
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

// MARK: - UI Functions
extension AuthenticationViewController {
    func setupUI() {
        Helpers.styleFilledButton(signupButton)
        Helpers.styleHollowButton(loginButton)
    }
    
}
    
// MARK: - UI Functions
extension AuthenticationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
