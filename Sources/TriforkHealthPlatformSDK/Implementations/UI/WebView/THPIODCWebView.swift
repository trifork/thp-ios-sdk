//
//  SwiftUIView.swift
//  
//
//  Created by Nicolai Harbo on 28/08/2023.
//

import SwiftUI

public struct THPIODCWebView: View {
    
    public let urlRequest: URLRequest
    @State private var isLoading = true
    @State private var error: Error? = nil
    
    public init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
    
    public var body: some View {
        ZStack {
            if let error = error {
                Text(error.localizedDescription)
            } else {
                WebView(
                    urlRequest: urlRequest,
                    isLoading: $isLoading,
                    error: $error
                )
                
                if isLoading {
                    ProgressView()
                }
            }
        }
//        .edgesIgnoringSafeArea(.all)
    }
}
