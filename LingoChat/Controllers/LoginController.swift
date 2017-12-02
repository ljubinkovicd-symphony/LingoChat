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
    
    // MARK: - Properties
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo_image")
        imageView.layer.cornerRadius = 100.0 // Half of the imageView height
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // disables conflict with constraints
        label.text = "Lingo Chat"
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor(rgb: 0x0077BE)
        textField.textAlignment = .center
        
        textField.layer.cornerRadius = 32.0
        textField.layer.masksToBounds = true
        
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.adjustsFontForContentSizeCategory = true
        
//        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
//        textField.leftView = paddingView
//        textField.leftViewMode = .always
        
        textField.text = "test@user.com"
        
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor(rgb: 0x0077BE)
        textField.textAlignment = .center
        
        textField.layer.cornerRadius = 32.0
        textField.layer.masksToBounds = true

        textField.isSecureTextEntry = true
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.adjustsFontForContentSizeCategory = true
        
//        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
//        textField.leftView = paddingView
//        textField.leftViewMode = .always
        
        textField.text = "123456"
        
        return textField
    }()
    
    let miniContainerView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor.clear
        
        return uiView
    }()
    
    let forgotMyPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Forgot my password", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        return button
    }()
    
    let createAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create an Account", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        return button
    }()
    
    let separatorView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor.white
        
        return uiView
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor(rgb: 0x0077BE), for: .normal) // Ocean Blue Color
        button.layer.cornerRadius = 16.0
        button.layer.masksToBounds = true
        
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupLoginScreenLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
         UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Button Tap Methods
    @objc func createAccountTapped(_ sender: UIButton) {
//        let registerController = RegisterController()
//        present(registerController, animated: true, completion: nil)
        
        // TODO: USE THIS
        let registerController = RegisterController()
        self.navigationController?.pushViewController(registerController, animated: true)
    }
    
    @objc func loginTapped() {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            } 
            
//            let messagesController = MessagesController(style: .plain)
//            self.present(messagesController, animated: true, completion: nil)
            
            let messagesController = MessagesController(style: .plain)
            self.navigationController?.pushViewController(messagesController, animated: true)
        }
    }
    
    // MARK: - Setup Layout
    fileprivate func setupLoginScreenLayout() {
        
        view.backgroundColor = UIColor(rgb: 0x0077BE) // Ocean Blue Color
        
        view.addSubview(logoImageView)
        view.addSubview(appNameLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(miniContainerView)
        view.addSubview(loginButton)
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: appNameLabel.topAnchor, constant: -32.0).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        appNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16.0).isActive = true
        appNameLabel.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32.0).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 8.0).isActive = true
        
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

