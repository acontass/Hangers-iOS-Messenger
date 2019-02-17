//
//  SettingsViewController.swift
//  Hangers-iOS-Messenger
//
//  Created by Anthony CONTASSOT-VIVIER on 01/02/2019.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var serverPortField: UITextField!
    @IBOutlet weak var portField: UITextField!
    @IBOutlet weak var ipField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        serverPortField.text = "\(SettingsManager.serverPort)"
        portField.text = "\(SettingsManager.clientPort)"
        ipField.text = SettingsManager.clientIpAddress
    }

    @IBAction func saveTouched() {
        SocketManager.shared.disconnect()
        if let text = serverPortField.text {
            SettingsManager.serverPort = Int32(text) ?? SettingsManager.serverPort
            serverPortField.text = "\(SettingsManager.serverPort)"
        }
        if let text = portField.text {
            SettingsManager.clientPort = Int32(text) ?? SettingsManager.clientPort
            portField.text = "\(SettingsManager.clientPort)"
        }
        if let text = ipField.text {
            SettingsManager.clientIpAddress = text
        }
        SocketManager.shared.connect()
        navigationController?.popViewController(animated: true)
    }
}
