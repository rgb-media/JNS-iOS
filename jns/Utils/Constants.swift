//
//  Constants.swift
//  JNS
//
//  Created by Adrian Picui on 03.04.2024.
//

import SwiftUI

class Constants {
    public static let SERVER        = "dev"
    public static let DOMAIN_NAME   = "jns.org"
    public static let HOMEPAGE_URL  = "https://" + SERVER + "." + DOMAIN_NAME + "/"
    public static let LATEST_URL    = HOMEPAGE_URL + "latest/"
    public static let OPINION_URL   = HOMEPAGE_URL + "opinion/"
    public static let MEDIA_URL     = HOMEPAGE_URL + "category/jns-tv/"
    public static let PROMOTION_URL = HOMEPAGE_URL + "wp-content/themes/rgb/ajax/api/print_header_banner_data.php"
    public static let MENU_URL      = HOMEPAGE_URL + "wp-content/themes/rgb/ajax/api/print_public_menus.php"
    public static let LOGIN_URL     = "https://" + (SERVER == "dev" ? "dev": "") + "crm.jns.org/api/login"
    public static let COMMENT_URL   = "https://" + (SERVER == "dev" ? "dev": "") + "crm.jns.org/user_comments/"

    public static let BREVO_URL     =  "https://api.brevo.com/v3/contacts"
    
    public static let PUSH_NOTIFICATION_ALERT       = Notification.Name("PushwooshAlert")

    public static let PROMOTION_ANIMATION_DURATION  = 0.3
    public static let MENU_ANIMATION_DURATION       = 0.4
    
    // Debug
    public static let DEBUG_WEB_VIEW        = true
    public static let DEBUG_TAG             = "DebugWebView"
    
    public static let DEBUG_PUSHWWOSH       = true
    public static let DEBUG_PUSHWOOSH_TAG   = "DebugPushwoosh"
    
    public static let CRMUSER_COOKIE        = "crmUser"
    public static let USERID_COOKIE         = "userId"
    public static let CRMSESSION_COOKIE     = "CRMSESSION"
    
    public static let USER_DATA             = "userData"
}
