//
//  SwiftUIView.swift
//  
//
//  Created by Nicolai Harbo on 31/08/2023.
//

import SwiftUI

public struct THPIODCSafariWebView: View {
    
    let url: URL

    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        SafariWebView(url: url)
            .ignoresSafeArea()
    }
}
