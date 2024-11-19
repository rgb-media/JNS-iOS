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
    @Published var loginCookies = [HTTPCookie]()
    
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
        
        $loginCookies.sink {
            if $0.isEmpty {
                self.webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                    var num = 3

                    for cookie in cookies {
                        if cookie.name == Constants.CRMSESSION_COOKIE {
                            num -= 1
                            
                            self.webView.configuration.websiteDataStore.httpCookieStore.delete(cookie) {
                                print("CRMSESSION cookie deleted")

                                if num == 0 {
                                    self.webView.reload()
                                }
                            }
                        }
                        
                        if cookie.name == Constants.CRMUSER_COOKIE {
                            num -= 1
                            
                            self.webView.configuration.websiteDataStore.httpCookieStore.delete(cookie) {
                                print("CRM user cookie deleted")

                                if num == 0 {
                                    self.webView.reload()
                                }
                            }
                        }

                        if cookie.name == Constants.USERID_COOKIE {
                            num -= 1
                            
                            self.webView.configuration.websiteDataStore.httpCookieStore.delete(cookie) {
                                print("User id cookie deleted")

                                if num == 0 {
                                    self.webView.reload()
                                }
                            }
                        }
                    }
                    
                    if num > 0 {
                        self.webView.reload()
                    }
                }
            } else {
                for cookie in $0 {
                    self.webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
                }
            }
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
    
    func reload() {
        webView.reload()
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
