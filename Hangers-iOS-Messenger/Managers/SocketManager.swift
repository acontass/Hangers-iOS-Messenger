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
    public private(set) var tcpClient: TCPClient?
    public private(set) var udpClient: UDPClient?

    public func connect(url: String, port: Int32, completion: (() -> Void)? = nil) {
        if SettingsManager.chatProtocol == .UDP {
            udpClient = UDPClient(address: url, port: port)
            isConnected = true
            completion?()
        }
        else {
            tcpClient = TCPClient(address: url, port: port)
            switch tcpClient!.connect(timeout: 4) {
            case .success:
                isConnected = true
                completion?()
            case .failure(let error):
                isConnected = false
                debugPrint(error.localizedDescription)
                completion?()
            }
        }
    }

    public func send(str: String, completion: (() -> Void)? = nil) {
        if SettingsManager.chatProtocol == .UDP {
            switch udpClient!.send(string: str) {
            case .success:
                completion?()
            case .failure(let e):
                debugPrint(e.localizedDescription)
            }
        }
        else {
            switch tcpClient!.send(string: str) {
            case .success:
                completion?()
            case .failure(let e):
                debugPrint(e.localizedDescription)
            }
        }
    }

    public func read(size: Int, completion: ((String) -> Void)? = nil) {
        if SettingsManager.chatProtocol == .UDP {
            let ret = udpClient?.recv(size)
            if let buff = ret?.0, let str = String(bytes: buff, encoding: .utf8) {
                completion?(str)
            }
        }
        else {
            if let buff = tcpClient?.read(size), let str = String(bytes: buff, encoding: .utf8) {
                completion?(str)
            }
        }
    }

    public func disconnect(completion: (() -> Void)? = nil) {
        tcpClient?.close()
        udpClient?.close()
        isConnected = false
        completion?()
    }
}
