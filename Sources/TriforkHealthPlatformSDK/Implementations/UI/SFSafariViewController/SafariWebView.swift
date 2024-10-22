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
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = false
        config.entersReaderIfAvailable = false
        
        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.dismissButtonStyle = .cancel
        safariViewController.delegate = context.coordinator
        return safariViewController
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) { }
    
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        var parent: SafariWebView
        
        init(_ parent: SafariWebView) {
            self.parent = parent
        }
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            NotificationCenter.default.post(name: .thpOIDCCancelNotification, object: nil, userInfo: nil)
        }
    }
}
