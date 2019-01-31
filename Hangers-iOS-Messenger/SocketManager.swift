//
//  SocketManager.swift
//  Hangers-iOS-Messenger
//
//  Created by Anthony CONTASSOT-VIVIER on 31/01/2019.
//  Copyright © 2019 me. All rights reserved.
//

import Foundation
import SwiftSocket

class SocketManager: NSObject {

    /**
     Singleton instance.
     */

    static let shared: SocketManager = {
        return SocketManager()
    }()

    public private(set) var isConnected: Bool = false
    public private(set) var client: TCPClient!

    public func connect(url: String, port: Int32, completion: () -> Void) {
        client = TCPClient(address: url, port: port)
        switch client.connect(timeout: 4) {
        case .success:
            isConnected = true
            completion()
        case .failure(let error):
            isConnected = false
            debugPrint(error.localizedDescription)
            completion()
        }
    }

    public func send(str: String, completion: (() -> Void)? = nil) {
        switch client.send(string: str) {
        case .success:
            completion?()
        case .failure(let e):
            debugPrint(e.localizedDescription)
        }
    }

    public func read(size: Int, completion: ((String) -> Void)? = nil) {
        if let buff = client.read(size), let str = String(bytes: buff, encoding: .utf8) {
            completion?(str)
        }
    }

    public func disconnect(completion: (() -> Void)? = nil) {
        client.close()
        isConnected = false
        completion?()
    }
}
