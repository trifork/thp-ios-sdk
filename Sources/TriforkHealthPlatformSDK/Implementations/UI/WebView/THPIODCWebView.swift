//
//  SwiftUIView.swift
//  
//
//  Created by Nicolai Harbo on 28/08/2023.
//

import SwiftUI

public struct THPIODCWebView: View {
    
    public let urlRequest: URLRequest
    
    public init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
    
    public var body: some View {
        VStack {
            Text("This is what we want to load:")
            Text(urlRequest.url?.absoluteString ?? ".. no url")
        }
    }
}
