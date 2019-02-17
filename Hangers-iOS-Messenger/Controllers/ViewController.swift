//
//  ViewController.swift
//  Hangers-iOS-Messenger
//
//  Created by Anthony CONTASSOT-VIVIER on 31/01/2019.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var tablviewBottomConstraint: NSLayoutConstraint!

    private var messages = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        SocketManager.shared.delegate = self
        messagesTableView.rowHeight = UITableView.automaticDimension
        messagesTableView.estimatedRowHeight = 44
        messageTextField.delegate = self
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: nil, using: { notification in
            let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
            self.tablviewBottomConstraint.constant = -keyboardSize.height
        })

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: nil, using: { notification in
            self.tablviewBottomConstraint.constant = 0
        })

        SocketManager.shared.connect()
    }

    @IBAction func sendTouched() {
        if let text = messageTextField.text {
            SocketManager.shared.send(str: text) {
                self.messageTextField.text = ""
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        cell.messageLabel.text = messages[indexPath.row]
        return cell
    }
}

extension ViewController: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTouched()
        return true
    }
}

extension ViewController: SocketDelegate {

    public func didReceive(message: String) {
        self.messages = message.components(separatedBy: "\n")
        self.messagesTableView.reloadData()
        messagesTableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }

}

