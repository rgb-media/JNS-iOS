//
//  WebViewModel.swift
//  JNS
//
//  Created by Adrian Picui on 03.04.2024.
//

import Combine
import WebKit

class WebViewModel: ObservableObject {
    @Published var urlString    = Constants.HOMEPAGE_URL
    @Published var canGoBack    = false
    @Published var canGoForward = false
    @Published var isLoading    = false
    @Published var isArticle    = false
    @Published var loginCookie  = HTTPCookie(properties: [
        .domain: ".zman.co.il",
        .path: "/",
        .name: "dummy_data",
        .value: "{}",
        .secure: "TRUE",
        .expires: NSDate(timeIntervalSinceNow: 604800)// 7 days
    ])!
    
    let webView: WKWebView
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        
        webView.scrollView.bounces = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reload(_:)), for: .valueChanged)
        webView.scrollView.refreshControl = refreshControl
        
        setupBindings()
    }
    
    @objc private func reload(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        webView.reload()
    }
    
    public func setDelegate(_ delegate: WebViewDelegate) {
        webView.uiDelegate = delegate
        webView.navigationDelegate = delegate
        
        webView.configuration.userContentController.add(delegate, name: "IOS")
    }
    
    private func setupBindings() {
        webView.publisher(for: \.canGoBack)
            .assign(to: &$canGoBack)
        
        webView.publisher(for: \.canGoForward)
            .assign(to: &$canGoForward)
        
        webView.publisher(for: \.isLoading)
            .assign(to: &$isLoading)
        
        $urlString.sink {
            if Constants.DEBUG_WEB_VIEW {
                print("\(Constants.DEBUG_TAG) - url current: \($0)")
                print("\(Constants.DEBUG_TAG) - url webView: \(String(describing: self.webView.url?.absoluteString))")
            }
            
            guard let url = URL(string: $0) else {
                return
            }
            
            self.webView.load(URLRequest(url: url))
        }
        .store(in: &cancellables)
        
        $loginCookie.sink {
            self.webView.configuration.websiteDataStore.httpCookieStore.setCookie($0)
        }
        .store(in: &cancellables)
        
        $isArticle.sink {
            if self.isArticle && !$0 {
                self.webView.evaluateJavaScript("rgb.closePopupArticleInApp()") { result, error in
                    if Constants.DEBUG_WEB_VIEW {
                        print("\(Constants.DEBUG_TAG) - evaluateJavaScript error: \(String(describing: error))")
                        print("\(Constants.DEBUG_TAG) - evaluateJavaScript result: \(String(describing: result))")
                    }
                }
            }
        }
        .store(in: &cancellables)
    }
    
    func loadUrl() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    func goForward() {
        webView.goForward()
    }
    
    func goBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            isArticle = false
        }
    }
}
