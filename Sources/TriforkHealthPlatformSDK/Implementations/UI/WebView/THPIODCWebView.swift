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
    @Binding var isPresented: Bool
    
    public init(
        urlRequest: URLRequest,
        isPresented: Binding<Bool>
    ) {
        self.urlRequest = urlRequest
        self._isPresented = isPresented
    }
    
    public var body: some View {
        ZStack {
            if let error = error {
                Text(error.localizedDescription)
            } else {
                WebView(
                    urlRequest: urlRequest,
                    isLoading: $isLoading,
                    error: $error,
                    isPresented: $isPresented
                )
                
                if isLoading {
                    ProgressView()
                }
            }
        }
    }
}
