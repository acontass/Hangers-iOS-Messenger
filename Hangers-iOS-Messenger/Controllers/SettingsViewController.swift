//
//  SettingsViewController.swift
//  Hangers-iOS-Messenger
//
//  Created by Anthony CONTASSOT-VIVIER on 01/02/2019.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var portField: UITextField!
    @IBOutlet weak var ipField: UITextField!
    @IBOutlet weak var protocolSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        portField.text = "\(SettingsManager.port)"
        ipField.text = SettingsManager.ipAddress
        protocolSegmentedControl.selectedSegmentIndex = (SettingsManager.chatProtocol == .UDP) ? 0 : 1
    }

    @IBAction func saveTouched() {
        SocketManager.shared.disconnect()
        if let text = portField.text {
            SettingsManager.port = Int32(text) ?? 4242
            portField.text = "\(SettingsManager.port)"
        }
        if let text = ipField.text {
            SettingsManager.ipAddress = text
        }
        SettingsManager.chatProtocol = SettingsManager.eChatProtocol.init(rawValue: protocolSegmentedControl.titleForSegment(at: protocolSegmentedControl.selectedSegmentIndex)!)!
        if (SettingsManager.chatProtocol == .UDP) {
            SocketManager.shared.connect(url: SettingsManager.ipAddress, port: SettingsManager.port)
        }
        navigationController?.popViewController(animated: true)
    }
}
