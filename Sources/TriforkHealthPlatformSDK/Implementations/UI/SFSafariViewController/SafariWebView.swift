//
//  File.swift
//  
//
//  Created by Nicolai Harbo on 31/08/2023.
//

import SwiftUI
import SafariServices

struct SafariWebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = false
        config.entersReaderIfAvailable = false
        
        let safariViewController: SFSafariViewController
        safariViewController = SFSafariViewController(
                url: url,
                configuration: config
        )
        safariViewController.dismissButtonStyle = .cancel
        
        return safariViewController
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) { }
}

extension SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        NotificationCenter.default.post(name: .thpOIDCCancelNotification, object: nil, userInfo: nil)
    }
}
