//
//  WebView.swift
//  JNS
//
//  Created by Adrian Picui on 21.03.2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView  {
        let wkWebView = WKWebView()
        
        wkWebView.evaluateJavaScript("navigator.userAgent") { result, error in
            if error == nil, let userAgent = result as? String {
                wkWebView.customUserAgent = userAgent + " rgbmedia-app ios app"
                
                let request = URLRequest(url: url)
                wkWebView.load(request)
            }
        }
        
        return wkWebView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
}
