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

class IoTSampleTabBarController: UITabBarController {

    @objc var mqttStatus: String = "Disconnected"
    @objc var front_door_camera: String = "esp32/cam_3"
    @objc var send_message: String = "esp32/send_message"
    @objc var recieve_message: String = "esp32/recieve_message"
    @objc var back_door_camera: String = "esp32/cam_0"
    @objc var get_alarm_status: String = "esp32/alarm_status"
    @objc var front_alarm_on: String = "esp32/alarm_0_on"
    @objc var front_alarm_off: String = "esp32/alarm_0_off"
    @objc var back_alarm_on: String = "esp32/alarm_1_on"
    @objc var back_alarm_off: String = "esp32/alarm_1_off"
    @objc var front_motion_on: String = "esp32/motion_0_on"
    @objc var front_motion_off: String = "esp32/motion_0_off"
    @objc var back_motion_on: String = "esp32/motion_1_on"
    @objc var back_motion_off: String = "esp32/motion_1_off"
    @objc var motion_notification_on: String = "esp32/motion_notification_on"
    @objc var motion_notification_off: String = "esp32/motion_notification_off"
    @objc var alarm_notification_on: String = "esp32/alarm_notification_on"
    @objc var alarm_notification_off: String = "esp32/alarm_notification_off"
    @objc var motion_detected_front: String = "esp32/motion_detected_1"
    @objc var door_opened_front: String = "esp32/door_opened_1"
    @objc var motion_detected_back: String = "esp32/motion_detected_0"
    @objc var door_opened_back: String = "esp32/door_opened_0"
    @objc var motion_status_front: String = "esp32/motion_status_1"
    @objc var door_status_front: String = "esp32/door_status_1"
    @objc var motion_status_back: String = "esp32/motion_status_0"
    @objc var door_status_back: String = "esp32/door_status_0"
    
}
