//
//  MessagesController.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 11/21/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MessagesController: UITableViewController {
    
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
    
    private let cellId = "reuseIdentifier"
    private var ref: DatabaseReference!
    private var refHandle: DatabaseHandle?
    private var chatRefHandle: DatabaseHandle?

    
    private var users: [LCUser]! = []
    
    // TEST COUNT
    private var testCount = 0
    
    private var currentUserProfileImageUrl: String?

    private var dateFormatter: DateFormatter?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        // Initialize date formatter______________________________________
        dateFormatter = DateFormatter()
        dateFormatter?.dateStyle = .medium
        dateFormatter?.timeStyle = .medium
        dateFormatter?.locale = Locale(identifier: "en_US") // Dec 2, 2017 (if timeStyle == .none)
        // _______________________________________________________________
        
        let currentUser = Auth.auth().currentUser
        
//        if let user = currentUser {
//
//            print(user.uid)
//            
//            ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
//
//                guard let userDict = snapshot.value as? NSDictionary else { return }
//
//                let username = userDict[Constants.UserFields.username] as? String ?? ""
//                let email = userDict[Constants.UserFields.email] as? String ?? ""
//                let profileImageUrl = userDict[Constants.UserFields.profileImageUrl] as? String ?? "attachment_icon"
//
//                let lcUser = LCUser(username: username, email: email, profileImageUrl: profileImageUrl)
//
//                DispatchQueue.main.async {
//                    self.setupNavigationBar(with: lcUser)
//                }
//            })
//
//        } else {
//            return
//        }
        
        tableView.separatorStyle = .none
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        // OBSERVE USERS
        refHandle = ref.child("users").observe(.childAdded, with: { [weak self] (snapshot) in
            
            guard let strongSelf = self else { return }
            
//            print("OTHER_USER: \(snapshot.key)") // this is the user uid (read from the database)
//            print("CURRENTLY_LOGGED_IN_USER: \(Auth.auth().currentUser!.uid)") // This is the currently logged in user's uid
            
            // Added
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            var snapshotDict = snapshot as? DataSnapshot
            let userValue = snapshotDict?.value as? NSDictionary
            
            // uid = fromId (sender), toId = receiver
            var userChats: NSDictionary = [:]
            
            let toId = snapshot.key // this is the selected user row
            
            if uid != toId {
                userChats = ["\(uid)": true,
                             "\(toId)": true]
            } else {
                userChats = ["\(uid)": true] // Chatting with yourself...
                
                let username = userValue?[Constants.UserFields.username] as? String ?? "Unknown"
                let profileImageUrl = userValue?[Constants.UserFields.profileImageUrl] as? String ?? "usa_icon"
                
                DispatchQueue.main.async {
                    strongSelf.currentUserProfileImageUrl = profileImageUrl
                    strongSelf.setupNavigationBar(with: LCUser(username: username, profileImageUrl: profileImageUrl))
                }
            }
            
            strongSelf.ref.child("user-chats").observeSingleEvent(of: .value, with: { [weak self] (userChatsnapshot) in
                
                for child in userChatsnapshot.children {
                    
                    let childSnapshot = child as? DataSnapshot
                    
                    let rootKey = childSnapshot!.key
                    
                    let userChatsDictionary = userChatsnapshot.value as? NSDictionary
                    let currentUserDictionary = userChatsDictionary![rootKey] as? NSDictionary
                    
                    if NSDictionary(dictionary: currentUserDictionary!).isEqual(userChats) {
                        
                        print("Current User Dict: \(currentUserDictionary)\nOther User Dict: \(userChats)")
                        
                        print("ROOT KEY: \(rootKey)")
                        
                    strongSelf.ref.child("chats").child(rootKey).observeSingleEvent(of: .value, with: { (chatSnapshot) in
                        
                            var chatSnapshotDict = chatSnapshot as? DataSnapshot
                            let chatValue = chatSnapshotDict?.value as? NSDictionary
                        
                            let username = userValue?[Constants.UserFields.username] as? String ?? "Unknown"
                            let profileImageUrl = userValue?[Constants.UserFields.profileImageUrl] as? String ?? "usa_icon"
                        
                        print("PROFILE_IMG_URL: \(profileImageUrl)")
                        
                            let lastMessage = chatValue?["last-message"] as? String ?? "You became friends with \(username)"
                            let messageTimestamp = chatValue?["timestamp"] as? Int ?? Int(Date().timeIntervalSince1970)
                        
                        let userObject = LCUser(userId: toId, username: username, profileImageUrl: profileImageUrl, timestamp: messageTimestamp, lastMessage: lastMessage)
                        
                            DispatchQueue.main.async {
                                strongSelf.users.append(userObject)
                                strongSelf.tableView.insertRows(at: [IndexPath(row: strongSelf.users.count - 1, section: 0)], with: .automatic)
                            }
                        })
                        
                    } // end of if statement
                } // end of for loop
                })
        })
        
        
    
        
        
        
        
        
        
        
        
        
        
        
        
        
        // TODO: Get latest message between users
//        ref.child("user-chats").observeSingleEvent(of: .value, with: { (snapshot) in
//
//            for child in snapshot.children {
//
//                let childSnapshot = child as? DataSnapshot
//
//                print("USER_CHAT_KEY: \(childSnapshot!.value!)")
//            }
//        })
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Setup Layout Methods
    fileprivate func setupNavigationBar(with user: LCUser) {
        
        navigationItem.titleView = currentUserTitleContainer
        currentUserTitleContainer.addSubview(profileImageView)
        currentUserTitleContainer.addSubview(userNameLabel)
        
        // Place user information into views
        profileImageView.loadImageUsingCache(with: user.profileImageUrl!)
        userNameLabel.text = user.username
        
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
        
        // Setup bar buttons inside navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
    }
    
    // MARK: - Button Tap Methods
    @objc func logoutTapped() {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil) // Don't need ??
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let lcUser = self.users[indexPath.row]
        
//        if lcUser.userId! == Auth.auth().currentUser?.uid {
//
//            print("AM I GETTING HERE?")
//
//            if let profileImgUrl = lcUser.profileImageUrl {
//                currentUserProfileImageUrl = profileImgUrl
//            }
//        }
        
        let username = lcUser.username!
        let profileImageUrl = lcUser.profileImageUrl!
        let lastMessage = lcUser.lastMessage!
        let messageTimestamp = lcUser.timestamp!
        
//        if let profileImageUrl = profileImageUrl {
        cell.userImageView.loadImageUsingCache(with: profileImageUrl)
//        }
        
        cell.usernameLabel.text = "\(username)"
        cell.userMessageDateLabel.text = dateFormatter?.string(from: Date(timeIntervalSince1970: TimeInterval(messageTimestamp)))
        cell.userPasswordLabel.text = "\(lastMessage)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        //        self.present(chatLogController, animated: true, completion: nil)
        
        let user = self.users[(indexPath as NSIndexPath).row]
        
        print("CURRENT_ID: \(Auth.auth().currentUser!.uid) VS OTHER_ID: \(user.userId!)")
        print("PROFILE_PICTURE: \(user.profileImageUrl!)")
        
        // TODO: Uncomment
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.userSnapshot = user
        chatLogController.currentlyLoggedInUserProfileImageUrl = currentUserProfileImageUrl

        self.navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
    // MARK: - Deinitialize
    deinit {
        if let refHandle = refHandle {
            self.ref.child("users").removeObserver(withHandle: refHandle)
        }
    }
}
