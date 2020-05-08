//
//  ViewController.swift
//  WebClient


import UIKit
import SocketIO

//https://shahaf-mezin-chat-nodejs.herokuapp.com
class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true)])
        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) {data, ack in
            print("----------socket connected------------")
            socket.emit("hello", "Im connected")
        }
        socket.on("hello") {data, ack in
            print(data.description)
        }
        socket.connect()
    }
}


