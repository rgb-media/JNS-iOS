//
//  Constants.swift
//  JNS
//
//  Created by Adrian Picui on 03.04.2024.
//

class Constants {
    public static let SERVER        = "www"
    public static let DOMAIN_NAME   = "jns.org"
    public static let HOMEPAGE_URL  = "https://" + SERVER + "." + DOMAIN_NAME + "/"
    public static let LATEST_URL    = HOMEPAGE_URL + "latest/"
    public static let OPINION_URL   = HOMEPAGE_URL + "opinion/"
    public static let MEDIA_URL     = HOMEPAGE_URL + "category/jns-tv/"
    public static let PROMOTION_URL = HOMEPAGE_URL + "wp-content/themes/rgb/ajax/api/print_header_banner_data.php"
    public static let MENU_URL      = HOMEPAGE_URL + "wp-content/themes/rgb/ajax/api/print_public_menus.php"
    public static let LOGIN_URL     = "https://crm.jns.org/api/login"

    public static let BREVO_URL     =  "https://api.brevo.com/v3/contacts"
    
    public static let APP_SECRET    = "s2lekaqc8dmo73q7b8xs1fyddp2t2zn1"
    public static let BREVO_API_KEY = "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"

    public static let PROMOTION_ANIMATION_DURATION  = 0.3
    public static let MENU_ANIMATION_DURATION       = 0.4
    
    // Debug
    public static let DEBUG_WEB_VIEW        = true
    public static let DEBUG_TAG             = "DebugWebView"
    
    public static let DEBUG_PUSHWWOSH       = true
    public static let DEBUG_PUSHWOOSH_TAG   = "DebugPushwoosh"
}
