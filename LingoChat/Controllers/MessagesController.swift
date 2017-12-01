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
    
    private let cellId = "reuseIdentifier"
    private var ref: DatabaseReference!
    private var refHandle: DatabaseHandle?
    
//    private var users: [LCUser]! = []
    private var users: [DataSnapshot]! = []

    // TEST COUNT
    private var testCount = 0
    
    private var currentUserProfileImageUrl: String?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(createNewUserTapped)
        )
        
        ref = Database.database().reference()
        
        refHandle = ref.child("users").observe(.childAdded, with: { [weak self] (snapshot) in
            
            guard let strongSelf = self else { return }
            
            print("OTHER_USER: \(snapshot.key)") // this is the user uid (read from the database)
            print("CURRENTLY_LOGGED_IN_USER: \(Auth.auth().currentUser!.uid)") // This is the currently logged in user's uid
            
            DispatchQueue.main.async {
                strongSelf.users.append(snapshot)
                strongSelf.tableView.insertRows(at: [IndexPath(row: strongSelf.users.count - 1, section: 0)], with: .automatic)
            }
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
    
    @objc func createNewUserTapped() {
        
        testCount += 1
        
        let testUserEmail = "test_user\(testCount)@email.com"
        let testUserPassword = "123456"
        
        // Register into Firebase
        Auth.auth().createUser(withEmail: testUserEmail, password: testUserPassword) { (user, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let values = [
                "email" : testUserEmail,
                "password" : testUserPassword
            ]
            
            self.ref.child("users").child(uid).updateChildValues(values)
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
        
        // Unpack user info from Firebase DataSnapshot
        let userSnapshot = self.users[indexPath.row]
        
        if userSnapshot.key == Auth.auth().currentUser?.uid {
            
            guard let currentUser = userSnapshot.value as? [String : Any] else { return cell }
            
            if let profileImgUrl = currentUser[Constants.UserFields.profileImageUrl] as? String {
                currentUserProfileImageUrl = profileImgUrl
            }
        }
        
//        print("USER_SNAPSHOT_KEY: \(String(describing: userSnapshot.key))")
        
        guard let user = userSnapshot.value as? [String : Any] else { return cell }
        
        let email = user[Constants.UserFields.email] as? String ?? ""
        let password = user[Constants.UserFields.password] as? String ?? ""
        let profileImageUrl = user[Constants.UserFields.profileImageUrl] as? String
        
//        print("\n\n\n\(userSnapshot.key) -> \(email)")
        
        if let profileImageUrl = profileImageUrl {
            cell.userImageView.loadImageUsingCache(with: profileImageUrl)
        }
        
        cell.userEmailLabel.text = "UserEmail: \(email)"
        cell.userMessageDateLabel.text = Date().description
        cell.userPasswordLabel.text = "UserPwd: \(password)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        //        self.present(chatLogController, animated: true, completion: nil)
        
        let user = self.users[(indexPath as NSIndexPath).row]
        
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
