//
//  MessagesController.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 11/19/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit

class ChatLogController: UIViewController {

    let textInputContainer: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor.red

        return uiView
    }()

    let attachmentButton: UIView = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "attachment_icon"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.green

        return button
    }()

    let messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your message..."
        textField.borderStyle = .line
        textField.backgroundColor = UIColor.yellow

        return textField
    }()

    let sendMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "send_message_icon"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.cyan

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        setupChatLayout()
    }

    fileprivate func setupChatLayout() {

        view.addSubview(textInputContainer)

        textInputContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        textInputContainer.heightAnchor.constraint(equalToConstant: 56).isActive = true
        textInputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textInputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

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
}

