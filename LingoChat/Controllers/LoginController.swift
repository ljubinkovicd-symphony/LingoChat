//
//  ViewController.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 11/18/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {
    
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
        
        textField.text = "123456"
        
        return textField
    }()
    
    let miniContainerView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor.brown
        
        return uiView
    }()
    
    let forgotMyPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.green
        button.setTitle("Forgot my password...", for: .normal)
        button.setTitleColor(UIColor.brown, for: .normal)
        
        return button
    }()
    
    let createAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.green
        button.setTitle("Create an Account", for: .normal)
        button.setTitleColor(UIColor.brown, for: .normal)
        button.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
        
        return button
    }()
    
    let separatorView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor.yellow
        
        return uiView
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.blue
        button.setTitleColor(UIColor.cyan, for: .normal)
        button.layer.cornerRadius = 16.0
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupLoginScreenLayout()
    }
    
    // MARK: - Button Tap Methods
    @objc func createAccountTapped(_ sender: UIButton) {
        let registerController = RegisterController()
//        loginController.messagesController = self
        present(registerController, animated: true, completion: nil)
    }
    
    @objc func loginTapped() {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let messagesController = ChatLogController()
            self.present(messagesController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Setup Layout
    fileprivate func setupLoginScreenLayout() {
        
        view.addSubview(loginOrRegisterLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(miniContainerView)
        view.addSubview(loginButton)
        
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
        
        miniContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        miniContainerView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8.0).isActive = true
        miniContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16.0).isActive = true
        miniContainerView.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32.0).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0).isActive = true
        
        miniContainerView.addSubview(separatorView)
        miniContainerView.addSubview(forgotMyPasswordButton)
        miniContainerView.addSubview(createAccountButton)
        
        separatorView.centerXAnchor.constraint(equalTo: miniContainerView.centerXAnchor).isActive = true
        separatorView.centerYAnchor.constraint(equalTo: miniContainerView.centerYAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
        separatorView.heightAnchor.constraint(equalTo: miniContainerView.heightAnchor, constant: -16.0).isActive = true
        
        forgotMyPasswordButton.centerYAnchor.constraint(equalTo: miniContainerView.centerYAnchor).isActive = true
        forgotMyPasswordButton.leftAnchor.constraint(equalTo: miniContainerView.leftAnchor, constant: 8.0).isActive = true
        forgotMyPasswordButton.rightAnchor.constraint(equalTo: separatorView.leftAnchor, constant: -8.0).isActive = true
        
        createAccountButton.centerYAnchor.constraint(equalTo: miniContainerView.centerYAnchor).isActive = true
        createAccountButton.leftAnchor.constraint(equalTo: separatorView.rightAnchor, constant: 8.0).isActive = true
        createAccountButton.rightAnchor.constraint(equalTo: miniContainerView.rightAnchor, constant: -8.0).isActive = true
    }
}

