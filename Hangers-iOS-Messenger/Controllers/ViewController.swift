//
//  ViewController.swift
//  Hangers-iOS-Messenger
//
//  Created by Anthony CONTASSOT-VIVIER on 31/01/2019.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var connectionButton: UIBarButtonItem!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var tablviewBottomConstraint: NSLayoutConstraint!

    private var messages = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.delegate = self
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: nil, using: { notification in
            let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
            self.tablviewBottomConstraint.constant = -keyboardSize.height + 64
        })

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: nil, using: { notification in
            self.tablviewBottomConstraint.constant = 0
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        let flag = SettingsManager.chatProtocol == .UDP
        connectionButton.title = (flag) ? nil : "Connect"
        connectionButton.isEnabled = !flag
        messageTextField.isEnabled = flag
        sendButton.isEnabled = flag
    }

    @IBAction func connect() {
        if !SocketManager.shared.isConnected {
            SocketManager.shared.connect(url: SettingsManager.ipAddress, port: SettingsManager.port) {
                self.connectionButton.title = SocketManager.shared.isConnected ? "Disconnect" : "Connect"
                self.messageTextField.placeholder = SocketManager.shared.isConnected ? "Type your message" : "Connect before type messages"
                self.sendButton.isEnabled = SocketManager.shared.isConnected
                self.messageTextField.isEnabled = SocketManager.shared.isConnected
            }
        }
        else {
            SocketManager.shared.disconnect() {
                self.connectionButton.title = "Connect"
                self.sendButton.isEnabled = false
                self.messageTextField.isEnabled = false
                self.messageTextField.placeholder = "Connect before write message"
                self.messages = []
                self.messagesTableView.reloadData()
            }
        }
    }

    @IBAction func sendTouched() {
        if let text = messageTextField.text {
            SocketManager.shared.send(str: text) {
                self.messageTextField.text = ""
                var validatedText = String()
                while validatedText == "" {
                    SocketManager.shared.read(size: 1024) { receivedText in
                        validatedText = receivedText
                        self.messages = receivedText.components(separatedBy: "\n")
                        self.messagesTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "MessageCell")
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
}

extension ViewController: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sendTouched()
        return true
    }
}

