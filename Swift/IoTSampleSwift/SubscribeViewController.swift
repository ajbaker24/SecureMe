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

class SubscribeViewController: UIViewController {

 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBOutlet var backDoor: UIImageView!
    @IBOutlet var frontDoor: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.hidesBackButton = true
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        let tabBarViewController = tabBarController as! IoTSampleTabBarController

        iotDataManager.subscribe(toTopic: tabBarViewController.front_door_camera, qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            (payload) ->Void in
          //Get the current image from the data buffer being sent over from the IoT devices and display it
            let curImage = UIImage(data: payload)
            DispatchQueue.main.async {
                self.frontDoor.image = curImage
            }
        } )
        iotDataManager.subscribe(toTopic: tabBarViewController.back_door_camera, qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            (payload) ->Void in
           
            let curImage = UIImage(data: payload)
            //Get the current image from the data buffer being sent over from the IoT devices and display it
            DispatchQueue.main.async {
                self.backDoor.image = curImage
            }
        } )
    }
    //Unsubscribe from the camera views when exiting
    override func viewWillDisappear(_ animated: Bool) {
        let iotDataManager = AWSIoTDataManager(forKey: AWS_IOT_DATA_MANAGER_KEY)
        let tabBarViewController = tabBarController as! IoTSampleTabBarController
        iotDataManager.unsubscribeTopic(tabBarViewController.front_door_camera)
        iotDataManager.unsubscribeTopic(tabBarViewController.back_door_camera)
    }
}

