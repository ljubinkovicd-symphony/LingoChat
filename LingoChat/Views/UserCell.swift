//
//  UserCell.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 11/26/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    let userImageView = UIImageView()
    let userEmailLabel = UILabel()
    let userPasswordLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        userImageView.backgroundColor = UIColor.blue
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        userPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(userImageView)
        addSubview(userEmailLabel)
        addSubview(userPasswordLabel)
        
        // Create views dictionary for visual format
        let viewsDict = [
            "userImage": userImageView,
            "userEmail": userEmailLabel,
            "userPassword": userPasswordLabel
            ] as [String : Any]
        
        let verticalFormatString = "V:|-[userImage]-[userEmail]-[userPassword]-|"
        let horizontalFormatString = "H:|-[userImage]-[userEmail]-[userPassword]-|"
        
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: verticalFormatString,
            options: [],
            metrics: nil,
            views: viewsDict
        )
        
        let horizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: horizontalFormatString,
            options: [],
            metrics: nil,
            views: viewsDict
        )
        
        NSLayoutConstraint.activate(verticalConstraints)
        NSLayoutConstraint.activate(horizontalConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
}
