//
//  UserCell.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 11/26/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.blue
        imageView.layer.cornerRadius = 32.0 // Half of the imageView height
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = UIColor.darkGray
        
        return label
    }()
    
    let userMessageDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor.lightGray
        
        return label
    }()
    
    let userPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor.lightGray
        
        return label
    }()
    
    let separatorView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor.red
        
        return uiView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(userImageView)
        addSubview(usernameLabel)
        addSubview(userMessageDateLabel)
        addSubview(userPasswordLabel)
        addSubview(separatorView)
        
        userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 64.0).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0).isActive = true
        
        usernameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8.0).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: userMessageDateLabel.leadingAnchor, constant: -8.0).isActive = true
        
        userMessageDateLabel.bottomAnchor.constraint(equalTo: usernameLabel.bottomAnchor).isActive = true
        userMessageDateLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 8.0).isActive = true
        userMessageDateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true
        
        userPasswordLabel.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor).isActive = true
        userPasswordLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8.0).isActive = true
        userPasswordLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true
        
//        separatorView.widthAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 64.0 + 8.0).isActive = true // 64 is the imageView width and 8 is the left constraint of the imageView
        separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
}
