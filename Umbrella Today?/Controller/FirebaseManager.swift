//
//  FirebaseManager.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 1/3/20.
//  Copyright © 2020 Fiesta Togo Inc. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class FirebaseManager {
    static var currentUser: User?
    
    static func listenForUserChange() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("auth changed")
            if let user = user {
                currentUser = user
            } else {
                currentUser = nil
            }
        }
    }
    
}
