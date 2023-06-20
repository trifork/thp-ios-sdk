//
//  File.swift
//  
//
//  Created by Nicolai Harbo on 16/06/2023.
//

import Foundation

public protocol THP {
    /// Configures the `TriforkHealthPlatformSDK`
    /// The configuration needs to be called before any other functionalities can be used
    /// You should only call this function once.
    /// - Parameter configuration: The actual configuration
    func configure(configuration: THPConfiguration)
    
    /// Gives you access to the auth features of the SDK.
    var auth: THPAuth { get }
}
