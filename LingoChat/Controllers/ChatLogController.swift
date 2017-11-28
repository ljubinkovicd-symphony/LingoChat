//
//  MessagesController.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 11/19/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

private let cellId = "cellId"

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var ref: DatabaseReference!
    var userSnapshot: DataSnapshot!
    
    // TESTING PURPOSES
    var myMessages: [String] = []
    
    let textInputContainer: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor.white
        
        return uiView
    }()
    
    let attachmentButton: UIView = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "attachment_icon"), for: .normal)
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    let messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your message..."
        textField.borderStyle = .line
        
        return textField
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "send_message_icon"), for: .normal)
        button.contentMode = .scaleAspectFit
        
        button.addTarget(self, action: #selector(sendMessageTapped), for: .touchUpInside)
        
        return button
    }()
    
    let separatorLine: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor.gray
        
        return uiView
    }()
    
    // MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messageTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        navigationItem.title = "\(userSnapshot.key)" // Tapped user row's uid
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsetsMake(16, 16, 16, 16)
        collectionView?.frame = CGRect(x: 0, y: 0, width: (collectionView?.frame.width)!, height: (collectionView?.frame.height)! - 56.0) // 56.0 is the height of the text input container
        collectionView?.backgroundColor = UIColor.white
        collectionView?.keyboardDismissMode = .interactive
        
        setupChatLayout()
        
        registerForKeyboardNotifications()
    }
    
    //  MARK: - CollectionView Data Source Delegate Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myMessages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! ChatMessageCell
        
        cell.messageTextView.text = myMessages[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    // MARK: - Button Tap Methods
    @objc func sendMessageTapped() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        if messageTextField.text != "" {
            // uid = fromId (sender), toId = receiver
            var userChats: NSDictionary = [:]
            
            let toId = userSnapshot.key // this is the selected user row
            
            if uid != toId {
                userChats = ["\(uid)": true,
                             "\(toId)": true]
            } else {
                userChats = ["\(uid)": true] // Chatting with yourself...
            }
            
            ref.child("user-chats").observeSingleEvent(of: .value) { (snapshot) in

                for child in snapshot.children {

                    let childSnapshot = child as? DataSnapshot
                    let rootKey = childSnapshot!.key

                    let userChatsDictionary = snapshot.value as? NSDictionary
                    let smt = userChatsDictionary![rootKey] as? NSDictionary

                    if NSDictionary(dictionary: smt!).isEqual(userChats) {
                        print("ROOT: \(rootKey) -> \(smt!.description)")

                        let chatKey = self.ref.child("chats").child(rootKey).key

                        // Update chats/chatId/chatObject
                        let chatIdRef = self.ref.child("chats/\(chatKey)")
                        print("CHAT_ID_REF: \(chatIdRef)")

                        // Update messages/chatId/messageId/messageObject
                        let messagesChatIdRef = self.ref.child("messages").child(chatKey).childByAutoId()

                        // These 2 are the same
//                        print("MY_CHAT_KEY: \(chatKey)")
//                        print("ROOT_KEY: \(rootKey)")

                        let chatInfo = ["last-message": self.messageTextField.text!,
                                        "timestamp": Int(Date().timeIntervalSince1970)] as [String : Any]
//
                        chatIdRef.updateChildValues(chatInfo)

                        let message = ["user-id": uid,
                                       "message": self.messageTextField.text!,
                                       "timestamp": Int(Date().timeIntervalSince1970)] as [String : Any]

                        messagesChatIdRef.setValue(message)
//                        print(messagesChatIdRef.key)
//                        let messages = ["\(messageId)": message]

                        // Data fan-out: https://firebase.google.com/docs/database/ios/structure-data?authuser=0#fanout
//                        let childUpdates = ["/chats/\(chatKey)": chatInfo,
//                                            "/user-chats/\(chatKey)": userChats,
//                                            "/messages/\(chatKey)": messages] as [String : Any]

                        // USE SET VALUE TO UPDATE DATA AT SPECIFIED LOCATION

//                        self.ref.updateChildValues(childUpdates)
                        
                        DispatchQueue.main.async {
                            self.myMessages.append(self.messageTextField.text!)
                            self.collectionView?.reloadData()
                        }
                        
                        return
                    }
                } // end of for loop...
                
                
                let chatKey = self.ref.child("chats").childByAutoId().key
                
                let chatInfo = ["last-message": self.messageTextField.text!,
                                "timestamp": Int(Date().timeIntervalSince1970)] as [String : Any]
                
                let message = ["user-id": uid,
                               "message": self.messageTextField.text!,
                               "timestamp": Int(Date().timeIntervalSince1970)] as [String : Any]
                
                let messageId = self.ref.childByAutoId().key
                let messages = ["\(messageId)": message]
                
                // Data fan-out: https://firebase.google.com/docs/database/ios/structure-data?authuser=0#fanout
                let childUpdates = ["/chats/\(chatKey)": chatInfo,
                                    "/user-chats/\(chatKey)": userChats,
                                    "/messages/\(chatKey)": messages] as [String : Any]
                
                // USE SET VALUE TO UPDATE DATA AT SPECIFIED LOCATION
                
                self.ref.updateChildValues(childUpdates)
                
                DispatchQueue.main.async {
                    self.myMessages.append(self.messageTextField.text!)
                    self.collectionView?.reloadData()
                }
                
            } // end of ref.child("user-chats")...
            
            // UPDATE THIS PART____________________________________________________________________________________________________________
//            let chatKey = self.ref.child("chats").childByAutoId().key
//
//            let chatInfo = ["last-message": self.messageTextField.text!,
//                            "timestamp": Int(Date().timeIntervalSince1970)] as [String : Any]
//
//            let message = ["user-id": uid,
//                           "message": self.messageTextField.text!,
//                           "timestamp": Int(Date().timeIntervalSince1970)] as [String : Any]
//
//            let messageId = self.ref.childByAutoId().key
//            let messages = ["\(messageId)": message]
//
//            // Data fan-out: https://firebase.google.com/docs/database/ios/structure-data?authuser=0#fanout
//            let childUpdates = ["/chats/\(chatKey)": chatInfo,
//                                "/user-chats/\(chatKey)": userChats,
//                                "/messages/\(chatKey)": messages] as [String : Any]
//
//            // USE SET VALUE TO UPDATE DATA AT SPECIFIED LOCATION
//
//            self.ref.updateChildValues(childUpdates)
//
//            DispatchQueue.main.async {
//                self.myMessages.append(self.messageTextField.text!)
//                self.collectionView?.reloadData()
//            }
            // ____________________________________________________________________________________________________________
        }
    }
    
    var textInputContainerViewBottomAchor: NSLayoutConstraint?
    
    // MARK: - Setup Layout
    fileprivate func setupChatLayout() {
        
        view.addSubview(textInputContainer)
        view.addSubview(separatorLine)
        
        separatorLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        separatorLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: textInputContainer.topAnchor).isActive = true
        
        textInputContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        textInputContainer.heightAnchor.constraint(equalToConstant: 56.0).isActive = true
        textInputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textInputContainerViewBottomAchor = textInputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        textInputContainerViewBottomAchor?.isActive = true
        
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
    }
    
    // MARK: - Handle Keyboard Methods
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ChatLogController.keyboardWillShow(_:)),
            name: .UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ChatLogController.keyboardWillHide(_:)),
            name: .UIKeyboardWillHide,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        textInputContainerViewBottomAchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        let keyboardDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        textInputContainerViewBottomAchor?.constant = 0.0
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Dismiss Keyboard
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
}
