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
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
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

        let userID = Auth.auth().currentUser?.uid
        
        
//        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            let email = value?["email"] as? String ?? ""
////            let user = User(username: username)
//
////            print("USER_EMAIL: \(email)")
//
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }

        // TODO UNCOMMENT
//        ref.child("users").child(userID!).observe(DataEventType.value, with: { (snapshot) in
//            let userDictionary = snapshot.value as? NSDictionary
//
//            let email = userDictionary?["email"] as? String ?? ""
//            let password = userDictionary?["password"] as? String ?? ""
//
//            print("\nUSER_EMAIL: \(email)\nUSER_PASSWORD: \(password)")
//        })
        
        refHandle = ref.child("users").observe(.childAdded, with: { [weak self] (snapshot) in
            
            guard let strongSelf = self else { return }
            
            strongSelf.users.append(snapshot)
            strongSelf.tableView.insertRows(at: [IndexPath(row: strongSelf.users.count - 1, section: 0)], with: .automatic)
            
            // ____________________________________________________________________________________________________________
            let userDictionary = snapshot.value as? NSDictionary
            
//            print("\n")
//
//            for (key, value) in userDictionary! {
//                print("\(key) -> \(value)")
//            }
        })
        
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
        
        guard let user = userSnapshot.value as? [String : Any] else { return cell }
        
        let email = user[Constants.UserFields.email] as? String ?? ""
        let password = user[Constants.UserFields.password] as? String ?? ""
        let profileImageUrl = user[Constants.UserFields.profileImageUrl] as? String
        
        print("\n\n\n\(userSnapshot.key) -> \(email)")
        
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
        
        let user = users[(indexPath as NSIndexPath).row]
        
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.userSnapshot = user
        
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
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
}
