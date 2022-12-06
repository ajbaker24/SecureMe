/*
* Copyright 2010-2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

import UIKit
import AWSIoT

class PublishViewController: UIViewController {

    
    //Buttons for different actions for the IoT devices I have set up
    @IBOutlet var motionNotificationBtn: UIButton!
    
    @IBOutlet var frontAlarmBtn: UIButton!
    @IBOutlet var backAlarmBtn: UIButton!
    @IBOutlet var frontMotionBtn: UIButton!
    @IBOutlet var backMotionBtn: UIButton!
    @IBOutlet var alarmNotificationBtn: UIButton!
    
    //Variables to keep track of the alarm/notification status
    var front_alarm_status = false
    var back_alarm_status = false
    var front_motion_status = false
    var back_motion_status = false
    var alarm_notification_status = true
    var motion_notification_status = true
   
    //Generic Alert Popup used
    let doorAlert = UIAlertController(title: "DOOR OPENED!", message: "Someone opened the front door!", preferredStyle: .alert)
    let okBtn = UIAlertAction(title: "Ok", style: .default, handler: {(action)->Void in
                     
    })
    
    
    @IBOutlet var curAlarmState: UILabel!
    
   //When the view appears fetch the current alarm status, and also check for any alarm events
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.hidesBackButton = true
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        let tabBarViewController = tabBarController as! IoTSampleTabBarController
        doorAlert.addAction(okBtn)
        curAlarmState.text = "Armed"
        
        //Check for alarm status by publishing to the IoT devices which will publish back a topic that the app is subcribed to
        iotDataManager.publishString("Get Alarm Status", onTopic: tabBarViewController.get_alarm_status, qoS:.messageDeliveryAttemptedAtMostOnce)
       
        //Subscribe to motion status updates
        iotDataManager.subscribe(toTopic: tabBarViewController.motion_status_back, qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            (payload) ->Void in
           
            let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)
            
            
            print("received: \(String(describing: stringValue))")
            DispatchQueue.main.async {
                if(stringValue == "true"){
                    self.ActivityLog.text.append("Back Motion Detector Armed!\n")
                    self.back_motion_status = true
                    self.curAlarmState.text = "Armed"
                    
                }
                else{
                    self.ActivityLog.text.append("Back Motion Detector Disarmed!\n")
                    self.back_motion_status = false
                }
            }
        } )
        
        //Subscribes to alarms that publish if armed
        iotDataManager.subscribe(toTopic: tabBarViewController.motion_status_front, qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            (payload) ->Void in
            
            let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)
            
            
            print("received: \(String(describing: stringValue))")
            DispatchQueue.main.async {
                if(stringValue == "true"){
                    self.ActivityLog.text.append("Front Motion Detector Armed!\n")
                    self.front_motion_status = true
                    self.curAlarmState.text = "Armed"
                }
                else{
                    self.ActivityLog.text.append("Front Motion Detector Disarmed!\n")
                    self.front_motion_status = false
                }
            }
        } )
        
        //Subscribes to alarms that publish if armed
        iotDataManager.subscribe(toTopic: tabBarViewController.door_status_back, qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            (payload) ->Void in
         
            let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)
            
            
            print("received: \(String(describing: stringValue))")
            DispatchQueue.main.async {
                if(stringValue == "true"){
                    self.ActivityLog.text.append("Back Door Armed!\n")
                    self.back_alarm_status = true
                    self.curAlarmState.text = "Armed"
                }
                else{
                    self.ActivityLog.text.append("Back Door Disarmed!\n")
                    self.back_alarm_status = false
                }
                
            }
        } )
        //Subscribes to alarms that publish if armed
        iotDataManager.subscribe(toTopic: tabBarViewController.door_status_front, qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            (payload) ->Void in
            
            let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)
            
            
            print("received: \(String(describing: stringValue))")
            DispatchQueue.main.async {
                if(stringValue == "true"){
                    self.ActivityLog.text.append("Front Door Armed\n")
                    self.front_alarm_status = true
                    self.curAlarmState.text = "Armed"
                }
                else{
                    self.ActivityLog.text.append("Front Door Disarmed\n")
                    self.front_alarm_status = false
                }
            }
        } )
        //Subscribes to alarms that publish status updates if alarm notifications enabled
        if(alarm_notification_status == true){
        iotDataManager.subscribe(toTopic: tabBarViewController.door_opened_front, qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            (payload) ->Void in
           
            let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)
            
            
            print("received: \(String(describing: stringValue))")
            DispatchQueue.main.async {
                
                self.ActivityLog.text.append("Front Door Opened!\n")
                self.doorAlert.message = "Front Door Opened"
                self.doorAlert.title = "DOOR OPENED!"
                self.present(self.doorAlert, animated: true, completion: nil)
                
            }
        } )
            
            iotDataManager.subscribe(toTopic: tabBarViewController.door_opened_back, qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
                (payload) ->Void in
             
                let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)
                
                
                print("received: \(String(describing: stringValue))")
                DispatchQueue.main.async {
                    
                    self.ActivityLog.text.append("Back Door Opened!\n")
                    self.doorAlert.message = "Back Door Opened"
                    self.doorAlert.title = "DOOR OPENED!"
                    self.present(self.doorAlert, animated: true, completion: nil)
                }
            } )
            
            
            
        }
        
        //Subscribes to alarms that publish status updates if alarm notifications enabled
        if(motion_notification_status == true){
        
        iotDataManager.subscribe(toTopic: tabBarViewController.motion_detected_front, qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            (payload) ->Void in
          
            let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)
            
            
            print("received: \(String(describing: stringValue))")
            DispatchQueue.main.async {
                
                self.ActivityLog.text.append("Front Motion Detected!\n")
                self.doorAlert.message = "Front Motion Detected"
                self.doorAlert.title = "MOTION DETECTED!"
                self.present(self.doorAlert, animated: true, completion: nil)
            }
        } )
        iotDataManager.subscribe(toTopic: tabBarViewController.motion_detected_back, qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            (payload) ->Void in
       
            let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)
            
            
            print("received: \(String(describing: stringValue))")
            DispatchQueue.main.async {
                
                self.ActivityLog.text.append("Back Motion Detected!\n")
                self.doorAlert.message = "Back Motion Detected"
                self.doorAlert.title = "MOTION DETECTED!"
                self.present(self.doorAlert, animated: true, completion: nil)
            }
        } )
        }
    }
    //Publish to alarms to stop sending status updates back to IoS devices
    @IBAction func motionNotificationAction(_ sender: UIButton) {
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        let tabBarViewController = tabBarController as! IoTSampleTabBarController
      
        if(motion_notification_status == true){
            
            motion_notification_status = false
            iotDataManager.publishString("Turn motion notifications off", onTopic: tabBarViewController.motion_notification_off, qoS:.messageDeliveryAttemptedAtMostOnce)
        }
        else{
           
            motion_notification_status = true
            iotDataManager.publishString("Turn motion notifications on", onTopic: tabBarViewController.motion_notification_on, qoS:.messageDeliveryAttemptedAtMostOnce)
        }

       
    }
    //Publish to alarms to stop sending status updates back to IoS devices
    @IBAction func alarmNotificationAction(_ sender: UIButton) {
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        let tabBarViewController = tabBarController as! IoTSampleTabBarController
      
        if(alarm_notification_status == true){
            
            alarm_notification_status = false
            iotDataManager.publishString("Turn alarm notifications off", onTopic: tabBarViewController.alarm_notification_off, qoS:.messageDeliveryAttemptedAtMostOnce)
        }
        else{
           
            alarm_notification_status = true
            iotDataManager.publishString("Turn alarm notifications on", onTopic: tabBarViewController.alarm_notification_on, qoS:.messageDeliveryAttemptedAtMostOnce)
        }
    }
    //Turn the motion sensors on or off for the back door
    @IBAction func backMotionBtn(_ sender: UIButton) {
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        let tabBarViewController = tabBarController as! IoTSampleTabBarController
        
        if(back_motion_status == true){
            
            back_motion_status = false
            iotDataManager.publishString("Turn motion off", onTopic: tabBarViewController.back_motion_off, qoS:.messageDeliveryAttemptedAtMostOnce)
        }
        else{
           
            back_motion_status = true
            iotDataManager.publishString("Turn motion on", onTopic: tabBarViewController.back_motion_on, qoS:.messageDeliveryAttemptedAtMostOnce)
        }
    }
    
    @IBOutlet var ActivityLog: UITextView!
    //Turn on or off the front motion sensors
    @IBAction func frontMotionBtn(_ sender: UIButton) {
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        let tabBarViewController = tabBarController as! IoTSampleTabBarController
      
        if(front_motion_status == true){
            
            front_motion_status = false
            iotDataManager.publishString("Turn motion off", onTopic: tabBarViewController.front_motion_off, qoS:.messageDeliveryAttemptedAtMostOnce)
           
        }
        else{
           
            front_motion_status = true
            iotDataManager.publishString("Turn motion on", onTopic: tabBarViewController.front_motion_on, qoS:.messageDeliveryAttemptedAtMostOnce)
        }
    }
    //Turn on or off the back door alarm
    @IBAction func backAlarmBtn(_ sender: UIButton) {
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        let tabBarViewController = tabBarController as! IoTSampleTabBarController
        
        if(back_alarm_status == true){
            
            back_alarm_status = false
            iotDataManager.publishString("Turn Alarm off", onTopic: tabBarViewController.back_alarm_off, qoS:.messageDeliveryAttemptedAtMostOnce)
        }
        else{
           
            back_alarm_status = true
            iotDataManager.publishString("Turn alarm on", onTopic: tabBarViewController.back_alarm_on, qoS:.messageDeliveryAttemptedAtMostOnce)
        }
        
    }
    //Turn on or off the front door alarm
    @IBAction func frontAlarmBtn(_ sender: UIButton) {
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        let tabBarViewController = tabBarController as! IoTSampleTabBarController
     
        if(front_alarm_status == true){
            
            front_alarm_status = false
            iotDataManager.publishString("Turn Alarm off", onTopic: tabBarViewController.front_alarm_off, qoS:.messageDeliveryAttemptedAtMostOnce)
        }
        else{
           
            front_alarm_status = true
            iotDataManager.publishString("Turn alarm on", onTopic: tabBarViewController.front_alarm_on, qoS:.messageDeliveryAttemptedAtMostOnce)
        }
       
       
        
    }
    
    
}
