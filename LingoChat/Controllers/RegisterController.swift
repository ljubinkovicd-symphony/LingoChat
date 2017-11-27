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
import FirebaseStorage

class RegisterController: UIViewController {
    
    // MARK: - Properties
    private var ref: DatabaseReference! = Database.database().reference()
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.blue
        imageView.layer.cornerRadius = 75.0 // Half of the imageView height
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let loginOrRegisterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // disables conflict with constraints
        label.text = "Register here"
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
    
    let picker = UIImagePickerController()
    
    // The image that will go into the "Add Photo"
    var image: UIImage? {
        didSet {
            userProfileImageView.image = image
            userProfileImageView.isHidden = false
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        view.backgroundColor = UIColor.cyan
        setupLoginScreenLayout()
        
        print("LOADED REGISTER CONTROLLER")
    }
    
    // MARK: - Gesture Recognizer Methods
    @objc func userProfileImageViewTapped() {
        
        pickPhoto()
    }
    
    // MARK: - Button Methods
    @objc func registerTapped() {
        
        // Register into Firebase
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            // Successfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let uploadData = UIImageJPEGRepresentation(self.userProfileImageView.image!, 0.1) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let profileImgUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let values = [
                            "email": self.emailTextField.text!,
                            "password": self.passwordTextField.text!,
                            "profileImageUrl": profileImgUrl,
                        ] as [String : Any]
                        
                        self.ref.child("users").child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
                            
                            if err != nil {
                                print(err!)
                                return
                            }
                            
                            let messagesController = MessagesController(style: .plain)
                            self.navigationController?.pushViewController(messagesController, animated: true)
                        })
                    }
                    
                    print(metadata!)
                })
                
                //            self.ref.child("users").child((user?.uid)!).updateChildValues(values)
                
                //            self.ref.child("users").child((user?.uid)!).setValue(["email" : self.emailTextField.text!])
            }
        }
    }
    
    // MARK: - Setup Layout
    fileprivate func setupLoginScreenLayout() {
        
        view.addSubview(userProfileImageView)
        view.addSubview(loginOrRegisterLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        
        // Clickable ImageView
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(userProfileImageViewTapped))
        singleTap.numberOfTapsRequired = 1
        userProfileImageView.isUserInteractionEnabled = true
        userProfileImageView.addGestureRecognizer(singleTap)
        
        userProfileImageView.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        userProfileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userProfileImageView.bottomAnchor.constraint(equalTo: loginOrRegisterLabel.topAnchor, constant: -32.0).isActive = true
        
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


// MARK: - UINavigationControllerDelegate Extension
extension RegisterController: UINavigationControllerDelegate {}

// MARK: - UIImagePickerControllerDelegate Extension
extension RegisterController: UIImagePickerControllerDelegate {
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhoto() {
        if true || UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhotoAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: "Action sheet choice that indicates that a user can take a photo with his/her camera."),
                                                style: .default,
                                                handler: { _ in self.takePhotoWithCamera() })
            alertController.addAction(takePhotoAction)
        }
        
        let chooseFromLibraryAction = UIAlertAction(title: NSLocalizedString("Choose From Library", comment: "Action sheet choice that indicates that the user can select a picture from his/her photo library."),
                                                    style: .default,
                                                    handler: { _ in self.choosePhotoFromLibrary() })
        alertController.addAction(chooseFromLibraryAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerController Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if let theImage = image {
            image = theImage
            //            newUser?.profileImage = theImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
}



