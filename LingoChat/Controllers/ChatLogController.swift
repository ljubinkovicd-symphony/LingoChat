//
//  MessagesController.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 11/19/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class ChatLogController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var colView: UICollectionView!
    
    let textInputContainer: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor.green
        
        return uiView
    }()

    let attachmentButton: UIView = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "attachment_icon"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.green
        
        return button
    }()
    
    let messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your message..."
        textField.borderStyle = .line
        textField.backgroundColor = UIColor.yellow
        
        return textField
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "send_message_icon"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.cyan
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChatLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath)
        
        cell.backgroundColor = UIColor.orange
        
        return cell
    }
    
    // MARK: - Setup Layout
    fileprivate func setupChatLayout() {
        
        view.addSubview(textInputContainer)
        
        textInputContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        textInputContainer.heightAnchor.constraint(equalToConstant: 56).isActive = true
        textInputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textInputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        textInputContainer.addSubview(attachmentButton)
        textInputContainer.addSubview(messageTextField)
        textInputContainer.addSubview(sendMessageButton)
        
        attachmentButton.leftAnchor.constraint(equalTo: textInputContainer.leftAnchor, constant: 16.0).isActive = true
        attachmentButton.centerYAnchor.constraint(equalTo: textInputContainer.centerYAnchor).isActive = true
        attachmentButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        attachmentButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        messageTextField.leftAnchor.constraint(equalTo: attachmentButton.rightAnchor, constant: 8.0).isActive = true
        messageTextField.rightAnchor.constraint(equalTo: sendMessageButton.leftAnchor, constant: -8.0).isActive = true
        messageTextField.centerYAnchor.constraint(equalTo: textInputContainer.centerYAnchor).isActive = true
        
        sendMessageButton.rightAnchor.constraint(equalTo: textInputContainer.rightAnchor, constant: -8.0).isActive = true
        sendMessageButton.centerYAnchor.constraint(equalTo: textInputContainer.centerYAnchor).isActive = true
        sendMessageButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        sendMessageButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 16, right: 10)
        layout.itemSize = CGSize(width: self.view.frame.width - 20, height: 111)
        
        let colViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 56.0) // 56.0 = textInputContainer.height
        
        colView = UICollectionView(frame: colViewFrame, collectionViewLayout: layout)
        colView.delegate   = self
        colView.dataSource = self
        colView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        colView.backgroundColor = UIColor.white
        
        self.view.addSubview(colView)
    }
}


//class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
//
//    let textInputContainer: UIView = {
//        let uiView = UIView()
//        uiView.translatesAutoresizingMaskIntoConstraints = false
//        uiView.backgroundColor = UIColor.red
//
//        return uiView
//    }()
//
//    let attachmentButton: UIView = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(named: "attachment_icon"), for: .normal)
//        button.contentMode = .scaleAspectFit
//        button.backgroundColor = UIColor.green
//
//        return button
//    }()
//
//    let messageTextField: UITextField = {
//        let textField = UITextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.placeholder = "Enter your message..."
//        textField.borderStyle = .line
//        textField.backgroundColor = UIColor.yellow
//
//        return textField
//    }()
//
//    let sendMessageButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(named: "send_message_icon"), for: .normal)
//        button.contentMode = .scaleAspectFit
//        button.backgroundColor = UIColor.cyan
//
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
//        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        //        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
//        collectionView?.alwaysBounceVertical = true
//        collectionView?.backgroundColor = UIColor.white
//        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
//
//        collectionView?.keyboardDismissMode = .interactive
//
////        setupChatLayout()
//    }
//
//    // MARK: - CollectionViewDelegate Methods
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
//        cell.backgroundColor = UIColor.blue
//
//        return cell
//    }
//
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        collectionView?.collectionViewLayout.invalidateLayout()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        var height: CGFloat = 80
//        let width = UIScreen.main.bounds.width
//
//        return CGSize(width: width, height: height)
//    }
//
//    // MARK: - Setup Layout
//    fileprivate func setupChatLayout() {
//
//        view.addSubview(textInputContainer)
//
//        textInputContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        textInputContainer.heightAnchor.constraint(equalToConstant: 56).isActive = true
//        textInputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        textInputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//        textInputContainer.addSubview(attachmentButton)
//        textInputContainer.addSubview(messageTextField)
//        textInputContainer.addSubview(sendMessageButton)
//
//        attachmentButton.leftAnchor.constraint(equalTo: textInputContainer.leftAnchor, constant: 16.0).isActive = true
//        attachmentButton.centerYAnchor.constraint(equalTo: textInputContainer.centerYAnchor).isActive = true
//        attachmentButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
//        attachmentButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
//
//        messageTextField.leftAnchor.constraint(equalTo: attachmentButton.rightAnchor, constant: 8.0).isActive = true
//        messageTextField.rightAnchor.constraint(equalTo: sendMessageButton.leftAnchor, constant: -8.0).isActive = true
//        messageTextField.centerYAnchor.constraint(equalTo: textInputContainer.centerYAnchor).isActive = true
//
//        sendMessageButton.rightAnchor.constraint(equalTo: textInputContainer.rightAnchor, constant: -8.0).isActive = true
//        sendMessageButton.centerYAnchor.constraint(equalTo: textInputContainer.centerYAnchor).isActive = true
//        sendMessageButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
//        sendMessageButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
//    }
//}
//
