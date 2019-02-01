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

    override func viewDidLoad() {
        super.viewDidLoad()
        portField.text = "\(SettingsManager.port)"
        ipField.text = SettingsManager.ipAddress
    }

    @IBAction func saveTouched() {
        if let text = portField.text {
            SettingsManager.port = Int32(text) ?? 4242
            portField.text = "\(SettingsManager.port)"
        }
        if let text = ipField.text {
            SettingsManager.ipAddress = text
        }
    }
}
