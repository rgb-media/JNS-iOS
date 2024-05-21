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
        FirebaseApp.configure()
        
        Pushwoosh.sharedInstance().showPushnotificationAlert = false
        Pushwoosh.sharedInstance().delegate = self
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
        if Constants.DEBUG_PUSHWWOSH {
            print("onMessageReceived: ", message.payload?.description ?? "no data")
        }

        notificationReceived(message.payload)
    }
    
    //this event is fired when a user taps the notification
    func pushwoosh(_ pushwoosh: Pushwoosh, onMessageOpened message: PWMessage) {
        if Constants.DEBUG_PUSHWWOSH {
            print("onMessageOpened: ", message.payload?.description ?? "no data")
        }
        
        notificationReceived(message.payload)
    }
    
    private func notificationReceived(_ userInfo: [AnyHashable: Any]?) {
        if let json = PushNotificationManager.push().getCustomPushData(asNSDict: userInfo) {
            if let article = json["article"] as? String {
                let url = "\(Constants.HOMEPAGE_URL)\(article)"
                
                var title = "JNS"
                var message = "JNS"
                
                if let aps = userInfo?["aps"] as? [String: Any], let alert = aps["alert"] as? [String: Any] {
                    if let string = alert["title"] as? String {
                        title = string
                    }
                    
                    if let string = alert["body"] as? String {
                        message = string
                    }
                }
                
                let payload = PushAlertModel()
                payload.showAlert = UIApplication.shared.applicationState == .active
                payload.title = title
                payload.message = message
                payload.url = url
                
                NotificationCenter.default.post(name: Constants.PUSH_NOTIFICATION_ALERT, object: payload)
            }
        }
    }
}
