//
//  RegisterController.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 11/18/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterController: UIViewController {

    private var ref: DatabaseReference! = Database.database().reference()
    
    let loginOrRegisterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // disables conflict with constraints
        label.text = "Login or Create a New Account..."
        label.textAlignment = .center
        
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.borderStyle = .line
        textField.layer.cornerRadius = 8.0
        textField.layer.masksToBounds = true
        
        textField.text = "test@user.com"
        
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.borderStyle = .line
        textField.layer.cornerRadius = 8.0
        textField.layer.masksToBounds = true
        textField.isSecureTextEntry = true
        
        textField.text = "123456"
        
        return textField
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.backgroundColor = UIColor.blue
        button.setTitleColor(UIColor.cyan, for: .normal)
        button.layer.cornerRadius = 16.0
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.cyan
        setupLoginScreenLayout()
        
        print("LOADED REGISTER CONTROLLER")
    }
    
    // MARK: - Button Methods
    @objc func registerTapped() {
        print(123)
        // Register into Firebase
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let values = [
                "email" : self.emailTextField.text!,
                "password" : self.passwordTextField.text!
            ]
            
            self.ref.child("users").child((user?.uid)!).updateChildValues(values)
            
//            self.ref.child("users").child((user?.uid)!).setValue(["email" : self.emailTextField.text!])
        }
    }
    
    // MARK: - Setup Layout
    fileprivate func setupLoginScreenLayout() {
        
        view.addSubview(loginOrRegisterLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        
        loginOrRegisterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginOrRegisterLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginOrRegisterLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16.0).isActive = true
        loginOrRegisterLabel.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32.0).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: loginOrRegisterLabel.bottomAnchor, constant: 8.0).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32.0).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8.0).isActive = true
        
        registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32.0).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0).isActive = true
    }
}
