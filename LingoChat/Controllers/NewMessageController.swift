//
//  NewMessageController.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 12/8/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit
import FirebaseDatabase

private let cellId = "cellId"

class NewMessageController: UITableViewController {
    
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
    
    private var users: [LCUser]? = []
    
    // TEST COUNT
    private var testCount = 0
    
    var currentUserProfileImageUrl: String?
    
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
        
        tableView.separatorStyle = .none
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchAndListenForUsers()
    }
    
    // MARK: - Firebase Listen Event Methods
    fileprivate func fetchAndListenForUsers() {
        // OBSERVE USERS
        refHandle = ref.child("users").observe(.value, with: { [weak self] (snapshot) in
            
            guard let strongSelf = self else { return }
            
            for child in snapshot.children {
                
                // Get user value
                let childSnapshot = child as? DataSnapshot
                let userDictionary = childSnapshot!.value as? NSDictionary
                
                let uid = userDictionary?[Constants.UserFields.uid] as? String ?? ""
                let username = userDictionary?[Constants.UserFields.username] as? String ?? ""
                let email = userDictionary?[Constants.UserFields.email] as? String ?? ""
                let profileImageUrl = userDictionary?[Constants.UserFields.profileImageUrl] as? String ?? ""
                
                print("username: \(username), email: \(email)")
                
                let user = LCUser.init(userId: uid, username: username, email: email, profileImageUrl: profileImageUrl)
                
                strongSelf.users?.append(user)
                
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
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
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(
        //            title: "Logout",
        //            style: .plain,
        //            target: self,
        //            action: #selector(logoutTapped)
        //        )
        //
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(
        //            barButtonSystemItem: .compose,
        //            target: self,
        //            action: #selector(composeMessage)
        //        )
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let lcUser = self.users![indexPath.row]
        
        let username = lcUser.username
        let email = lcUser.email
        let profileImageUrl = lcUser.profileImageUrl
        
        if let profileImageUrl = profileImageUrl {
            cell.userImageView.loadImageUsingCache(with: profileImageUrl)
        }
        
        cell.usernameLabel.text = username!
        cell.userPasswordLabel.text = email!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = self.users![(indexPath as NSIndexPath).row]
        
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
