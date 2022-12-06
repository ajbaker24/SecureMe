//
//  MessagingViewController.swift
//  IoTSampleSwift
//
//  Created by Alex Baker on 12/4/22.
//  Copyright © 2022 Amazon. All rights reserved.
//
import UIKit
import AWSIoT

class MessagingViewController: UIViewController{
    
   
  
    //Create a message board view that displays messages from other connected IOS devices
    @IBOutlet weak var messageBoard: UITextView!
    @IBOutlet weak var inputText: UITextField!
    
    
    
    //Function to send messages to other users in the household over MQTT and AWS
    @IBAction func sendMessage(_ sender: Any) {
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        print(String(describing: inputText.text!))
        let tabBarViewController = tabBarController as! IoTSampleTabBarController
        iotDataManager.publishString(String(describing: inputText.text!) , onTopic: tabBarViewController.send_message, qoS:.messageDeliveryAttemptedAtMostOnce)
        
    }
    
    //On load check for any new messages
    override func viewWillAppear(_ animated: Bool) {
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        let tabBarViewController = tabBarController as! IoTSampleTabBarController
        self.tabBarController?.navigationItem.hidesBackButton = true
    iotDataManager.subscribe(toTopic: tabBarViewController.send_message, qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
    (payload) ->Void in
    let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)
    DispatchQueue.main.async {
        self.messageBoard.text.append(stringValue! as String)
        self.messageBoard.text.append("\n")
    }
    } )
    }
}
