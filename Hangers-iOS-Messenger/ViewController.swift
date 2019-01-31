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
    
    private var messages = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func connect() {
        if !SocketManager.shared.isConnected {
            SocketManager.shared.connect(url: /*"172.16.125.129"*/"127.0.0.1", port: 4242) {
                connectionButton.title = SocketManager.shared.isConnected ? "Disconnect" : "Connect"
                messageTextField.placeholder = SocketManager.shared.isConnected ? "Type your message" : "Connect before type messages"
                sendButton.isEnabled = SocketManager.shared.isConnected
                messageTextField.isEnabled = SocketManager.shared.isConnected
            }
        }
        else {
            SocketManager.shared.disconnect() {
                self.connectionButton.title = "Connect"
                self.sendButton.isEnabled = false
                self.messageTextField.isEnabled = false
                self.messageTextField.placeholder = "Connect before write message"
            }
        }
    }

    @IBAction func sendTouched() {
        if let text = messageTextField.text {
            SocketManager.shared.send(str: text) {
                self.messageTextField.text = ""
                SocketManager.shared.read(size: 1024) { receivedText in
                    self.messages = receivedText.components(separatedBy: "\n")
                    self.messagesTableView.reloadData()
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count - 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "MessageCell")
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
}

