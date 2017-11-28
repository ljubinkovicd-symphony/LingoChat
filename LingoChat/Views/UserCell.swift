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
    
    let userEmailLabel: UILabel = {
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
        addSubview(userEmailLabel)
        addSubview(userMessageDateLabel)
        addSubview(userPasswordLabel)
        addSubview(separatorView)
        
        userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 64.0).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0).isActive = true
        
        userEmailLabel.topAnchor.constraint(equalTo: userImageView.topAnchor).isActive = true
        userEmailLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8.0).isActive = true
        userEmailLabel.trailingAnchor.constraint(equalTo: userMessageDateLabel.leadingAnchor, constant: -8.0).isActive = true
        
        userMessageDateLabel.bottomAnchor.constraint(equalTo: userEmailLabel.bottomAnchor).isActive = true
        userMessageDateLabel.leadingAnchor.constraint(equalTo: userEmailLabel.trailingAnchor, constant: 8.0).isActive = true
        userMessageDateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true
        
        userPasswordLabel.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor).isActive = true
        userPasswordLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8.0).isActive = true
        userPasswordLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true
        
        separatorView.widthAnchor.constraint(equalToConstant: self.frame.size.width - 64.0 - 16.0).isActive = true // 64.0 is the width of the userImageView (+ 16.0 is the to take in account the horizontal constraint (userImageView leadingConstraint of 8.0 points, and 8.0 on the separatorView trailingConstraint) )
        separatorView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true
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
