//
//  SwiftUIView.swift
//  
//
//  Created by Nicolai Harbo on 31/08/2023.
//

import SwiftUI

struct THPIODCSafariWebView: View {
    
    let url: URL
    @Binding private var isPresented: Bool?
    
    var body: some View {
        SafariWebView(url: url)
            .ignoresSafeArea()
    }
}
