////
////  SwiftUIView.swift
////  
////
////  Created by Nicolai Harbo on 28/08/2023.
////
//
//import SwiftUI
//
//public struct THPIODCWebView: View {
//    
//    @State private var isLoading = true
//    @State private var error: Error? = nil
//    
//    private let urlRequest: URLRequest
//    private let loadingOverlayColor: Color
//    @Binding private var isPresented: Bool?
//    
//    public init(
//        urlRequest: URLRequest,
//        loadingOverlayColor: Color = .white,
//        isPresented: Binding<Bool?> = .constant(nil)
//    ) {
//        self.urlRequest = urlRequest
//        self.loadingOverlayColor = loadingOverlayColor
//        self._isPresented = isPresented
//    }
//    
//    public var body: some View {
//        ZStack {
//            if let error = error {
//                Text(error.localizedDescription)
//            } else {
//                WebView(
//                    urlRequest: urlRequest,
//                    isLoading: $isLoading,
//                    error: $error,
//                    isPresented: $isPresented
//                )
//                
//                if isLoading {
//                    loadingOverlayColor.overlay(ProgressView())
//                }
//            }
//        }
//        .edgesIgnoringSafeArea(.all)
//    }
//}
