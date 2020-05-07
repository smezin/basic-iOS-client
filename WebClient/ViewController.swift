//
//  ViewController.swift
//  WebClient
//
//  Created by hyperactive on 06/05/2020.
//  Copyright © 2020 hyperActive. All rights reserved.
//

import UIKit
import Starscream
//https://shahaf-mezin-chat-nodejs.herokuapp.com
class ViewController: UIViewController, WebSocketDelegate {
    
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let err = server.start(address: "https://basic-game-server.herokuapp.com", port: 80)
//        if err != nil {
//            print("server didn't start!")
//        }
//        server.onEvent = { event in
//            switch event {
//            case .text(let conn, let string):
//                let payload = string.data(using: .utf8)!
//                conn.write(data: payload, opcode: .textFrame)
//            default:
//                break
//            }
//        }
        //https://echo.websocket.org
        //https://basic-game-server.herokuapp.com
        var request = URLRequest(url: URL(string: "https://basic-game-server.herokuapp.com")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    // MARK: - WebSocketDelegate
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    
    // MARK: Write Text Action
    
    @IBAction func writeText(_ sender: UIBarButtonItem) {
        socket.write(string: "hello there!")
    }
    
    // MARK: Disconnect Action
    
    @IBAction func disconnect(_ sender: UIBarButtonItem) {
        if isConnected {
            sender.title = "Connect"
            socket.disconnect()
        } else {
            sender.title = "Disconnect"
            socket.connect()
        }
    }
    
}



