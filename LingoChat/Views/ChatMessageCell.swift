//
//  ChatMessageCell.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 11/19/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.clear
        textView.textColor = .cyan
        textView.isEditable = false
        
        return textView
    }()
    
    let bubbleView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor(rgb: 0xDCF8C6) // Light soft green color (HEX: #DCF8C6)
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
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    var profileImageViewLeftAnchor: NSLayoutConstraint?
    var profileImageViewRightAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCellLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupCellLayout() {
        
        addSubview(bubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
    
        // iOS 9 Constraints
        // BubbleView Constraints (the container)____________________________________________________________________________________________________________________________________
        bubbleViewRightAnchor = bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -48.0)
        bubbleViewRightAnchor?.isActive = true // 32 for image view width, 8 for left and right constraint of image view.
        
//        bubbleViewLeftAnchor = bubbleView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8.0)
        bubbleViewLeftAnchor = bubbleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 48.0)
//        bubbleViewLeftAnchor?.isActive = true
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200.0)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        // __________________________________________________________________________________________________________________________________________________________________________
        
        // MessageTextView Constraints_______________________________________________________________________________________________________________________________________________
        messageTextView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8.0).isActive = true
        messageTextView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8.0).isActive = true
        messageTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        // __________________________________________________________________________________________________________________________________________________________________________
        
        // ProfileImageView Constraints// ___________________________________________________________________________________________________________________________________________
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        profileImageViewRightAnchor = profileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0)
        profileImageViewRightAnchor?.isActive = true
        
        profileImageViewLeftAnchor = profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0)
//        profileImageViewLeftAnchor?.isActive = true
        
        profileImageView.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        // __________________________________________________________________________________________________________________________________________________________________________
    }
}
