////
////  File.swift
////  
////
////  Created by Nicolai Harbo on 29/08/2023.
////
//
//import SwiftUI
//import WebKit
//
//struct WebView: UIViewRepresentable {
//    
//    let urlRequest: URLRequest
//    @Binding var isLoading: Bool
//    @Binding var error: Error?
//    @Binding var isPresented: Bool?
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    func makeUIView(context: Context) -> WKWebView {
//        let preferences = WKPreferences()
//        preferences.javaScriptCanOpenWindowsAutomatically = false
//        
//        let configuration = WKWebViewConfiguration()
//        configuration.preferences = preferences
//        
//        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
//        webView.uiDelegate = context.coordinator
//        webView.navigationDelegate = context.coordinator
//        webView.scrollView.isScrollEnabled = true
//        
//        // Clear all cookies, just for good measure's sake
//        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
//        
//        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
//            WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records) {
//                webView.load(urlRequest)
//            }
//        }
//        
//        return webView
//    }
//    
//    func updateUIView(_ webView: WKWebView, context: Context) {}
//    
//    // MARK: - Coordinator
//    class Coordinator : NSObject, WKNavigationDelegate, WKUIDelegate {
//        
//        private var parent: WebView
//        private var ignoreError: Bool = false
//        
//        init(_ parent: WebView) {
//            self.parent = parent
//        }
//        
//        // MARK: - WKNavigationDelegate
//        
//        func webView(
//            _ webView: WKWebView,
//            decidePolicyFor navigationAction: WKNavigationAction,
//            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
//        ) {
//            ignoreError = false
//            decisionHandler(.allow)
//        }
//        
//        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            withAnimation {
//                parent.isLoading = true
//            }
//        }
//        
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            withAnimation {
//                parent.isLoading = false
//            }
//        }
//        
//        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//            if !ignoreError {
//                withAnimation {
//                    parent.isLoading = false
//                    parent.error = error
//                }
//            }
//        }
//        
//        func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//            if let url = webView.url, let configuration = THP.shared.configuration, url.absoluteString.starts(with: configuration.redirectUrl) {
//                withAnimation {
//                    parent.isLoading = true
//                }
//                
//                THP.shared.auth.handleRedirect(url: url)
//                ignoreError = true
//                
//                // handleRedirect(url:) loads in the background - might be nice for the UI to know, in some cases.
//                NotificationCenter.default.post(
//                    name: .thpOIDCLoadingTokenNotification,
//                    object: nil,
//                    userInfo: nil
//                )
//                
//                // Close the view
//                parent.isPresented = false
//            }
//        }
//        
//        // MARK: - WKUIDelegate
//        
//    }
//}
