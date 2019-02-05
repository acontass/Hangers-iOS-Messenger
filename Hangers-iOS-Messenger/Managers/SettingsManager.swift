//
//  SettingsManager.swift
//  Hangers-iOS-Messenger
//
//  Created by Anthony CONTASSOT-VIVIER on 01/02/2019.
//  Copyright © 2019 me. All rights reserved.
//

import Foundation

struct SettingsManager {

    public enum eChatProtocol: String {
        case TCP
        case UDP
    }

    static public var port: Int32 = 4242
    static public var ipAddress: String = "127.0.0.1"
    static public var chatProtocol: eChatProtocol = .TCP
}
