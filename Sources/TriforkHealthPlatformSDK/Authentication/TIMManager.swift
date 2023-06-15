//
//  TIMManager.swift
//  
//
//  Created by Nicolai Harbo on 15/06/2023.
//

import Combine
import Foundation
import TIM
import UIKit

protocol TIMManagerProtocol {
    func performOpenIDConnectFlow(flow: THPAuthenticationFlow, presentingViewController: UIViewController) -> AnyPublisher<JWT, THPAuthError>
    @discardableResult
    func handleRedirect(url: URL) -> Bool
    func clearAllUsers(except userId: String)
}

public class TIMManager {
    
    private let timAuth: TIMAuth
    private let timStorage: TIMDataStorage
    private let thpConfiguration: THPConfiguration
    
    public init(
        timAuth: TIMAuth = TIM.auth,
        timStorage: TIMDataStorage = TIM.storage,
        thpConfiguration: THPConfiguration
    ) {
        self.timAuth = timAuth
        self.timStorage = timStorage
        self.thpConfiguration = thpConfiguration
        configureTIM(for: .signin)
    }
}

// MARK: - Input

extension TIMManager: TIMManagerProtocol {
    func handleRedirect(url: URL) -> Bool {
        timAuth.handleRedirect(url: url)
    }
    
    func performOpenIDConnectFlow(flow: THPAuthenticationFlow, presentingViewController: UIViewController) -> AnyPublisher<JWT, THPAuthError> {
        configureTIM(for: flow)
        return timAuth.performOpenIDConnectLogin(presentingViewController: presentingViewController)
            .eraseToAnyPublisher()
    }
    
    func clearAllUsers(except userId: String) {
        timStorage.clear(userId: userId)
    }
}

// MARK: - Helpers

extension TIMManager {
    private func configureTIM(for flow: THPAuthenticationFlow) {
        TIM.configure(
            configuration: buildConfiguration(
                url: thpConfiguration.baseAuthURL,
                scopes: thpConfiguration.scopes,
                realm: thpConfiguration.realm,
                clientId: thpConfiguration.clientId,
                redirectURL: thpConfiguration.redirectUrl,
                flow: flow
            ),
            allowReconfigure: true
        )
    }
    
    private func buildConfiguration(url: URL, scopes: [String], realm: String, clientId: String, redirectURL: String, flow: THPAuthenticationFlow) -> TIMConfiguration {
        
        var params: [String: String] = [
            "ui_locales": Locale.applicationLocale.identifier.split(separator: "-")[0].description,
            "prompt": "login"
        ]

        params[thpConfiguration.loginFlowKey] = flow.rawValue
        
        return TIMConfiguration(
            timBaseUrl: url,
            realm: realm,
            clientId: clientId,
            redirectUri: URL(string: redirectURL)!,
            scopes: scopes,
            encryptionMethod: .aesGcm,
            additionalParameters: params
        )
    }
}
