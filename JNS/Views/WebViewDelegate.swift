//
//  WebViewDelegate.swift
//  JNS
//
//  Created by Adrian Picui on 03.04.2024.
//

import WebKit

class WebViewDelegate: NSObject {
    weak var webViewModel: WebViewModel?
    weak var showLoginPopup: LoginPopupObservable?
    weak var showLoadingOverlay: LoadingOverlayObservable?

    init(webViewModel: WebViewModel, showLoginPopup: LoginPopupObservable, showLoadingOverlay: LoadingOverlayObservable?) {
        self.webViewModel = webViewModel
        self.showLoginPopup = showLoginPopup
        self.showLoadingOverlay = showLoadingOverlay
    }
}

extension WebViewDelegate: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let dict = message.body as? [String: AnyObject] {
            let function = dict["key"] as? String
            
            if Constants.DEBUG_WEB_VIEW {
                print("\(Constants.DEBUG_TAG) - userContentController didReceive: \(function!)")
            }
            
            if function == "popupOpened" {
                webViewModel?.isArticle = true
            } else if function == "popupClosed" {
                webViewModel?.isArticle = false
            } else if function == "popupLoginOpened" {
                showLoginPopup?.value = true
            }
        }
    }
}

extension WebViewDelegate: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil ||  navigationAction.targetFrame?.isMainFrame == false {
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
        }

        return nil
    }
}

extension WebViewDelegate: WKNavigationDelegate {
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        print("WKNavigationDelegate - didStartProvisionalNavigation: \(webView.url!.absoluteString)")
        
        showLoadingOverlay?.value = true
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        print("WKNavigationDelegate - didCommit: \(webView.url!.absoluteString)")
        
        webViewModel?.isArticle = Utils.isArticle(url: webView.url!)
    }

//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        print("WKNavigationDelegate - decidePolicyFor: \(navigationAction.request.url!.absoluteString.prefix(80))")
//
//        decisionHandler(.allow)
//    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("WKNavigationDelegate - didFinish: \(webView.url!.absoluteString)")
        
        showLoadingOverlay?.value = false
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        //        print("WKNavigationDelegate - didFail: \(webView.url!.absoluteString)")
        
        showLoadingOverlay?.value = false
    }
}
