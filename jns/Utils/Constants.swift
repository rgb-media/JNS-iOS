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
    public static let PROMOTION_URL = "https://dl.dropbox.com/scl/fi/5i1eonsiyjs2ttq388mpa/print_header_banner_data.php.json?rlkey=jqxdaud7a2sorjy8z0uvd72fl&dl=0"// HOMEPAGE_URL + "wp-content/themes/rgb/ajax/api/print_header_banner_data.php"
    public static let MENU_URL      = "https://dl.dropbox.com/scl/fi/319btemyitcc42374rc8t/print_public_menus.php.json?rlkey=l4p8ogn83fiv9xu85bg1h9eg3&dl=0"//HOMEPAGE_URL + "wp-content/themes/rgb/ajax/api/print_public_menus.php"
    
    public static let PROMOTION_ANIMATION_DURATION  = 0.5
    public static let MENNU_ANIMATION_DURATION      = 0.7
    
    // Debug
    public static let DEBUG_WEB_VIEW        = true
    public static let DEBUG_TAG             = "DebugWebView"
    
    public static let DEBUG_PUSHWWOSH       = true
    public static let DEBUG_PUSHWOOSH_TAG   = "DebugPushwoosh"
}
