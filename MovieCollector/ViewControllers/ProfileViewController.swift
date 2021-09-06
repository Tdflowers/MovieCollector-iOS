//
//  ProfileViewController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/22/20.
//

import UIKit
import SwiftUI
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    var signUpButton:UIButton = {
        let button = UIButton.init(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        return button
    }()
    
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        
        if Auth.auth().currentUser != nil {
            
        } else {
            view.addSubview(signUpButton)
        }
        layoutConstraints()
        
        handle = Auth.auth().addStateDidChangeListener { auth, user in
          
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            signUpButton.isHidden = true
        } else {
            view.addSubview(signUpButton)
        }
        
    }
    
    func layoutConstraints () {
        if signUpButton.isDescendant(of: view) {
            NSLayoutConstraint.activate([
                signUpButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/8),
                signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3)
            ])
        }
    }
    
    @objc func signUpPressed () {
        //Popup signup / signin flow
        let hostingController = UIHostingController(rootView: LoginFlow())
           hostingController.rootView.dismiss = {
               hostingController.dismiss(animated: true, completion: nil)
           }
           present(hostingController, animated: true, completion: nil)

    }
}
