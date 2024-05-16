//
//  AppDelegate.swift
//  JNS
//
//  Created by Adrian Picui on 16.05.2024.
//

import Pushwoosh
import FirebaseCore

class AppDelegate: UIResponder, UIApplicationDelegate, PWMessagingDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //initialization code
        FirebaseApp.configure()
        
        //set custom delegate for push handling, in our case AppDelegate
        Pushwoosh.sharedInstance().delegate = self
        
        //register for push notifications
        Pushwoosh.sharedInstance().registerForPushNotifications()
        
        return true
    }
    
    //handle token received from APNS
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if Constants.DEBUG_PUSHWWOSH {
            print("\(Constants.DEBUG_PUSHWOOSH_TAG) - push notifications token: \(deviceToken.map { data in String(format: "%02.2hhx", data) }.joined())")
        }

        Pushwoosh.sharedInstance().handlePushRegistration(deviceToken)
    }
    
    //handle token receiving error
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if Constants.DEBUG_PUSHWWOSH {
            print("\(Constants.DEBUG_PUSHWOOSH_TAG) - didFailToRegisterForRemoteNotificationsWithError: \(String(describing: error))")
        }
        
        Pushwoosh.sharedInstance().handlePushRegistrationFailure(error)
    }
    
    //this is for iOS < 10 and for silent push notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Pushwoosh.sharedInstance().handlePushReceived(userInfo)
        completionHandler(.noData)
    }
    
    //this event is fired when the push gets received
    func pushwoosh(_ pushwoosh: Pushwoosh, onMessageReceived message: PWMessage) {
        print("onMessageReceived: ", message.payload?.description ?? "no data")
    }
    
    //this event is fired when a user taps the notification
    func pushwoosh(_ pushwoosh: Pushwoosh, onMessageOpened message: PWMessage) {
        print("onMessageOpened: ", message.payload?.description ?? "no data")
    }
}
