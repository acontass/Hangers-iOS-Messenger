//
//  SocketManager.swift
//  Hangers-iOS-Messenger
//
//  Created by Anthony CONTASSOT-VIVIER on 31/01/2019.
//  Copyright © 2019 me. All rights reserved.
//

import Foundation
import SwiftSocket

public protocol SocketDelegate {
    func didReceive(message: String)
}

class SocketManager: NSObject {

    /**
     Singleton instance.
     */

    static let shared: SocketManager = {
        return SocketManager()
    }()

    private let readSize: Int = 64

    public private(set) var udpClient: UDPClient?

    private var serverUdpQueue = DispatchQueue(label: "SEREVER_UDP_QUEUE", qos: .background)

    private var serverUdp: UDPServer?

    public var delegate: SocketDelegate?

    public func connect() {
        serverUdp = UDPServer(address: "0.0.0.0", port: SettingsManager.serverPort)
        serverUdpQueue.async {
            while (true) {
                if self.serverUdp?.fd == nil {
                    break
                }
                if let ret = self.serverUdp?.recv(self.readSize), let buff = ret.0, let str = String(bytes: buff, encoding: .utf8), let size = Int(str) {
//                    debugPrint("READ SIZE = \(str) --> \(size)")
                    if let ret2 = self.serverUdp?.recv(size), let buff = ret2.0, let str = String(bytes: buff, encoding: .utf8) {
                        DispatchQueue.main.async {
//                            debugPrint(str)
                            self.delegate?.didReceive(message: str)
                        }
                    }
                }
            }
        }
        udpClient = UDPClient(address: SettingsManager.clientIpAddress, port: SettingsManager.clientPort)
    }

    public func send(str: String, completion: (() -> Void)? = nil) {
        switch udpClient!.send(string: str) {
        case .success:
            completion?()
        case .failure(let e):
            debugPrint(e.localizedDescription)
        }
    }

    public func disconnect() {
        serverUdp?.close()
        udpClient?.close()
    }
}
