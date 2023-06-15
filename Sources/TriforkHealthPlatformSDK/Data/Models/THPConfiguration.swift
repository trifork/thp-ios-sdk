//
//  File.swift
//  
//
//  Created by Nicolai Harbo on 15/06/2023.
//

import Foundation
import TIM

public struct THPConfiguration {
    public let timAuth: TIMAuth
    public let baseAuthURL: URL
    public let scopes: [String]
    public let realm: String
    public let clientId: String
    public let redirectUrl: String
    public let loginFlowKey: String
    
    public init(
        timAuth: TIMAuth,
        scopes: [String],
        realm: String,
        clientId: String,
        redirectUrl: String,
        baseAuthURL: URL,
        loginFlowKey: String
    ) {
        self.timAuth = timAuth
        self.scopes = scopes
        self.realm = realm
        self.clientId = clientId
        self.redirectUrl = redirectUrl
        self.baseAuthURL = baseAuthURL
        self.loginFlowKey = loginFlowKey
    }
}
