//
//  WebView.swift
//  JNS
//
//  Created by Adrian Picui on 21.03.2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @EnvironmentObject var showLoginPopup: LoginPopupObservable
    @EnvironmentObject var showLoadingOverlay: LoadingOverlayObservable

    @ObservedObject var webViewModel: WebViewModel

    @Binding var contentOffset: CGPoint
    
    init(webViewModel: WebViewModel, contentOffset: Binding<CGPoint>) {
        self.webViewModel = webViewModel
        _contentOffset = contentOffset
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        webViewModel.setDelegate(WebViewDelegate(webViewModel: webViewModel, showLoginPopup: showLoginPopup, showLoadingOverlay: showLoadingOverlay))

        let wkWebView = webViewModel.webView

        wkWebView.scrollView.bounces = false
        wkWebView.scrollView.delegate = context.coordinator
        
        wkWebView.evaluateJavaScript("navigator.userAgent") { result, error in
            if error == nil, let userAgent = result as? String {
                wkWebView.customUserAgent = userAgent + " rgbmedia-app ios app"
                
                let url = URL(string: webViewModel.urlString)
                let request = URLRequest(url: url!)

                wkWebView.load(request)
            }
        }
        
        return wkWebView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        .init(contentOffset: $contentOffset)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        @Binding var contentOffset: CGPoint
        
        init(contentOffset: Binding<CGPoint>) {
            _contentOffset = contentOffset
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            contentOffset = scrollView.contentOffset
        }
    }
}
