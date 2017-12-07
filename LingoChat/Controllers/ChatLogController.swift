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

// TEST
import LanguageTranslatorV2

private let cellId = "cellId"

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Views
    let currentUserTitleContainer: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        //        uiView.backgroundColor = UIColor(rgb: 0xDCF8C6) // Light soft green color (HEX: #DCF8C6)
        uiView.backgroundColor = UIColor.clear // Light soft green color (HEX: #DCF8C6)
        uiView.layer.cornerRadius = 16.0
        uiView.layer.masksToBounds = true
        
        return uiView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "attachment_icon")
        imageView.backgroundColor = UIColor.red
        imageView.layer.cornerRadius = 16.0 // half of the imageView.height
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SOME USER"
        
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
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
    
    lazy var messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your message..."
        textField.borderStyle = .line
        textField.delegate = self
        
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
    
    let translateMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.init(named: "usa_icon") , for: .normal)
        button.contentMode = .scaleAspectFit
        
        button.addTarget(self, action: #selector(translateTapped), for: .touchUpInside)
        
        return button
    }()
    
    let separatorLine: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor.gray
        
        return uiView
    }()
    
    // MARK: - Properties
    private var ref: DatabaseReference!
    private var refHandle: DatabaseHandle?
    
    var userSnapshot: DataSnapshot!
    var currentlyLoggedInUserProfileImageUrl: String?
    
    // TESTING PURPOSES
    var myMessages: [Message] = []
    
    // MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messageTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup database reference
        ref = Database.database().reference()
        
        setupNavigationBar()
        
        fetchAndListenForMessagesForUsers()
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 58, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 58, 0)
        //        collectionView?.frame = CGRect(x: 0, y: 0, width: (collectionView?.frame.width)!, height: (collectionView?.frame.height)! - 56.0) // 56.0 is the height of the text input container
        collectionView?.backgroundColor = UIColor.white
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.delegate = self

        setupChatLayout()
        
        registerForKeyboardNotifications()
    }
    
    // MARK: - Configuration(Orientation) Change Methods
    //    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //
    //        collectionView?.collectionViewLayout.invalidateLayout()
    //    }
    
    // MARK: - Messages Related Methods
    fileprivate func handleSend() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        if messageTextField.text != "" {
            
            let messageText: String = messageTextField.text!
            messageTextField.text = nil
            
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
                        //                        print("ROOT: \(rootKey) -> \(smt!.description)")
                        
                        let chatKey = self.ref.child("chats").child(rootKey).key
                        
                        // Update chats/chatId/chatObject
                        let chatIdRef = self.ref.child("chats/\(chatKey)")
                        //                        print("CHAT_ID_REF: \(chatIdRef)")
                        
                        // Update messages/chatId/messageId/messageObject
                        let messagesChatIdRef = self.ref.child("messages").child(chatKey).childByAutoId()
                        
                        // These 2 are the same
                        //                        print("MY_CHAT_KEY: \(chatKey)")
                        //                        print("ROOT_KEY: \(rootKey)")
                        
                        let chatInfo = ["last-message": messageText,
                                        "timestamp": Int(Date().timeIntervalSince1970)] as [String : Any]
                        //
                        chatIdRef.updateChildValues(chatInfo)
                        
                        let message = ["user-id": uid,
                                       "message": messageText,
                                       "timestamp": Int(Date().timeIntervalSince1970)] as [String : Any]
                        
                        messagesChatIdRef.setValue(message) // this will automatically trigger the listener (for any new messages that are added)
                        
                        //                        let messageObject = Message(userId: uid, text: messageText, timestamp: Int(Date().timeIntervalSince1970))
                        //
                        //                        DispatchQueue.main.async {
                        //                            self.myMessages.append(messageObject)
                        //                            self.collectionView?.reloadData()
                        //                        }
                        
                        return
                    }
                } // end of for loop...
                
                
                let chatKey = self.ref.child("chats").childByAutoId().key
                
                let chatInfo = ["last-message": messageText,
                                "timestamp": Int(Date().timeIntervalSince1970)] as [String : Any]
                
                let message = ["user-id": uid,
                               "message": messageText,
                               "timestamp": Int(Date().timeIntervalSince1970)] as [String : Any]
                
                let messageId = self.ref.childByAutoId().key
                let messages = ["\(messageId)": message]
                
                // Data fan-out: https://firebase.google.com/docs/database/ios/structure-data?authuser=0#fanout
                let childUpdates = ["/chats/\(chatKey)": chatInfo,
                                    "/user-chats/\(chatKey)": userChats,
                                    "/messages/\(chatKey)": messages] as [String : Any]
                
                let messageObject = Message(userId: uid, text: messageText, timestamp: Int(Date().timeIntervalSince1970))
                
                self.ref.updateChildValues(childUpdates)
                
                DispatchQueue.main.async {
                    self.myMessages.append(messageObject)
                    self.collectionView?.reloadData()
                }
                
            } // end of ref.child("user-chats")...
        }
    }
    
    fileprivate func fetchAndListenForMessagesForUsers() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // uid = fromId (sender), toId = receiver
        var userChats: NSDictionary = [:]
        
        let toId = userSnapshot.key // this is the selected user row
        
        if uid != toId {
            userChats = ["\(uid)": true,
                         "\(toId)": true]
        } else {
            userChats = ["\(uid)": true] // Chatting with yourself...
        }
        
        ref.child("user-chats").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            guard let strongSelf = self else { return }
            
            for child in snapshot.children {
                
                let childSnapshot = child as? DataSnapshot
                
                let rootKey = childSnapshot!.key
                
                let userChatsDictionary = snapshot.value as? NSDictionary
                let currentUserDictionary = userChatsDictionary![rootKey] as? NSDictionary
                
                if NSDictionary(dictionary: currentUserDictionary!).isEqual(userChats) {
                    
                    let chatKey = strongSelf.ref.child("chats").child(rootKey).key
                    
                    strongSelf.refHandle = strongSelf.ref.child("messages").child(chatKey).observe(.childAdded, with: { (snapshot) in
                        
                        guard let dictionary = snapshot.value as? [String : Any] else { return }
                        
                        var snapshotDict = snapshot as? DataSnapshot
                        let value = snapshotDict?.value as? NSDictionary
                        
                        let userId = value?["user-id"] as? String ?? "no user id"
                        let text = value?["message"] as? String ?? "no message"
                        let timestamp = value?["timestamp"] as? Int ?? Int(Date().timeIntervalSince1970)
                        
                        //                        print("(\(userId), \(text), \(timestamp.description)\n\n")
                        
                        let messageObject = Message(userId: userId, text: text, timestamp: timestamp)
                        
                        DispatchQueue.main.async {
                            strongSelf.myMessages.append(messageObject)
                            strongSelf.collectionView?.reloadData()
                            strongSelf.collectionView?.scrollToItem(at: IndexPath.init(item: strongSelf.myMessages.count - 1, section: 0) , at: .bottom, animated: true)
                        }
                    }) // end of ref.child("messages") closure
                } // end of if statement
            } // end of for loop
        })
    }
    
    fileprivate func observeMessages() {
        
        refHandle = ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) in
            
            guard let strongSelf = self else { return }
            
            print(snapshot)
            
            //            strongSelf.fetchMessagesForUsers()
            //            DispatchQueue.main.async {
            //                strongSelf.collectionView?.reloadData()
            //            }
            }, withCancel: { (error) in
                print(error.localizedDescription)
        })
    }
    
    //  MARK: - CollectionView Data Source Delegate Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myMessages.count
    }
    
    var messageLeadingAnchor: NSLayoutConstraint?
    var messageTrailingAnchor: NSLayoutConstraint?
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! ChatMessageCell
        
        // Determines the cell layout and color based on who is sending and who is receiving the message
        setupCell(indexPath, cell)
        
        cell.messageTextView.text = myMessages[indexPath.item].text
        
        // modify bubbleView width
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: myMessages[indexPath.row].text!).width + 32
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80.0
        
        if let text = myMessages[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 20
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
    }

    // TODO: Implement UIMenuController for each collection view cell. (add options: Copy, Translate)
//    //____________________________________________________________________________________________________________________________________________________________________________________
//    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
//
//        let menuItem = UIMenuItem(title: "CUSTOM ACT", action: #selector(translateText))
//        let menuController = UIMenuController.shared
//        menuController.menuItems = [menuItem]
//
//        return true
//    }
//
//    @objc func translateText(for cellAtIndexPath: IndexPath) {
//
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//
//        return (action == NSSelectorFromString("copy:") || action == NSSelectorFromString("translateText:"))
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ChatMessageCell
//        if (action == NSSelectorFromString("copy:")) {
//            print("COPY CALLED!!!")
//        } else if (action == NSSelectorFromString("translateText:")) {
//            print("MY TRANSLATE METHOD CALLED!!!, \(cell?.messageTextView.text!)")
//        }
//    }
//    //____________________________________________________________________________________________________________________________________________________________________________________
    
    // MARK: - String Container Height Methods
    private func estimateFrameForText(text: String) -> CGRect {
        
        let size = CGSize(width: 200.0, height: 1000) // 200.0 is taken from ChatMessageCell.bubbleView.widthConstraint
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(
            with: size,
            options: options,
            attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)],
            context: nil
        )
    }
    
    // MARK: - Button Tap Methods
    @objc func sendMessageTapped() {
        
        handleSend()
    }
    
    @objc func translateTapped() {

        let detailsViewController = DetailViewController()
//        detailsViewController.modalPresentationStyle = .custom
        present(detailsViewController, animated: true, completion: nil)
        
        // TODO: UNCOMMENT
//        let languageTranslator = LanguageTranslator(username: Constants.IbmWatsonApi.username, password: Constants.IbmWatsonApi.password)
//        let failure = { (error: Error) in print(error) }
//
//        let listOfInputs: [String] = [myMessages[myMessages.count - 1].text!]
//
//        // Translating english to french
//        languageTranslator.translate(listOfInputs, from: Languages.spanish.rawValue, to: Languages.english.rawValue, failure: failure) { [weak self] translation in
//
//            guard let strongSelf = self else { return }
//
//            print(translation)
//
//            //            for i in 0..<translation.translations.count {
//            //                print(translation.translations[i].translation)
//            //            }
//
//            strongSelf.myMessages[strongSelf.myMessages.count - 1].text! = translation.translations[0].translation
//
//            DispatchQueue.main.async {
//                strongSelf.collectionView?.reloadData()
//            }
//        }
    }
    
    // MARK: - Setup Layout
    fileprivate func setupNavigationBar() {
        
        navigationItem.titleView = currentUserTitleContainer
        currentUserTitleContainer.addSubview(profileImageView)
        currentUserTitleContainer.addSubview(userNameLabel)
        
        // Place user information into views
        guard let user = userSnapshot.value as? [String : Any] else { return }
        profileImageView.loadImageUsingCache(with: user[Constants.UserFields.profileImageUrl] as? String ?? "attachment_icon")
        userNameLabel.text = user[Constants.UserFields.username] as? String ?? "NO_NAME"
        
        currentUserTitleContainer.widthAnchor.constraint(equalToConstant: view .frame.size.width / 2.0).isActive = true
        currentUserTitleContainer.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        currentUserTitleContainer.centerXAnchor.constraint(equalTo: navigationItem.titleView!.centerXAnchor).isActive = true
        currentUserTitleContainer.centerYAnchor.constraint(equalTo: navigationItem.titleView!.centerYAnchor).isActive = true
        
        profileImageView.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: currentUserTitleContainer.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: currentUserTitleContainer.leadingAnchor, constant: 8.0).isActive = true
        
        userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8.0).isActive = true
        userNameLabel.trailingAnchor.constraint(equalTo: currentUserTitleContainer.trailingAnchor, constant: -8.0).isActive = true
        userNameLabel.centerYAnchor.constraint(equalTo: currentUserTitleContainer.centerYAnchor).isActive = true
    }
    
    var textInputContainerViewBottomAchor: NSLayoutConstraint?
    
    fileprivate func setupCell(_ indexPath: IndexPath, _ cell: ChatMessageCell) {
        
        cell.messageTextView.textColor = UIColor.black
        
        // Sender (currently logged in user)
        if Auth.auth().currentUser!.uid == myMessages[indexPath.row].userId {
            cell.bubbleView.backgroundColor = UIColor(rgb: 0xDCF8C6) // Light soft green color (HEX: #DCF8C6)
            
            if let currentUserProfileImgUrl = currentlyLoggedInUserProfileImageUrl {
                cell.profileImageView.loadImageUsingCache(with: currentUserProfileImgUrl)
            }
            
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.bubbleViewRightAnchor?.isActive = true
            cell.profileImageViewLeftAnchor?.isActive = false
            cell.profileImageViewRightAnchor?.isActive = true
            
            
            // Receiver
        } else {
            
            guard let user = userSnapshot.value as? [String : Any] else { return }
            
            cell.bubbleView.backgroundColor = UIColor(rgb: 0xECE5DD) // Light gray color (HEX: #ECE5DD)
            cell.profileImageView.loadImageUsingCache(with: user[Constants.UserFields.profileImageUrl] as? String ?? "attachment_icon")
            
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.bubbleViewRightAnchor?.isActive = false
            cell.profileImageViewLeftAnchor?.isActive = true
            cell.profileImageViewRightAnchor?.isActive = false
        }
    }
    
    fileprivate func setupChatLayout() {
        
        // Set a background image in chat log__________________________________________
        UIGraphicsBeginImageContext((self.collectionView?.frame.size)!)
        UIImage(named: "chat_log_background")?.draw(in: (self.collectionView?.bounds)!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.collectionView?.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.init(patternImage: image!)
        //_____________________________________________________________________________
        
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
        textInputContainer.addSubview(translateMessageButton)
        
        attachmentButton.leftAnchor.constraint(equalTo: textInputContainer.leftAnchor, constant: 16.0).isActive = true
        attachmentButton.centerYAnchor.constraint(equalTo: textInputContainer.centerYAnchor).isActive = true
        attachmentButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        attachmentButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        messageTextField.leftAnchor.constraint(equalTo: attachmentButton.rightAnchor, constant: 8.0).isActive = true
        messageTextField.rightAnchor.constraint(equalTo: translateMessageButton.leftAnchor, constant: -8.0).isActive = true
        messageTextField.centerYAnchor.constraint(equalTo: textInputContainer.centerYAnchor).isActive = true
        
        translateMessageButton.rightAnchor.constraint(equalTo: sendMessageButton.leftAnchor, constant: -8.0).isActive = true
        translateMessageButton.centerYAnchor.constraint(equalTo: textInputContainer.centerYAnchor).isActive = true
        translateMessageButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        translateMessageButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
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
        
        if myMessages.count > 0 {
            collectionView?.scrollToItem(at: IndexPath.init(item: self.myMessages.count - 1, section: 0) , at: .bottom, animated: true)
        }
        
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
    
    // MARK: - Deinitialize
    deinit {
        if let refHandle = refHandle {
            self.ref.child("messages").removeObserver(withHandle: refHandle)
        }
    }
}

// MARK: - UITextFieldDelegate Methods
extension ChatLogController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
