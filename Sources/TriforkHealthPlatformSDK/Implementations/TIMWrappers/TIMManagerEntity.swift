//
//  TIMManager.swift
//  
//
//  Created by Nicolai Harbo on 15/06/2023.
//

import AppAuth
import Combine
import Foundation
import TIM
import TIMEncryptedStorage
import UIKit

public class TIMManagerEntity {
    
    private let thpConfiguration: THPConfiguration
    private let customOIDExternalUserAgent: OIDExternalUserAgent?
    
    public init(
        thpConfiguration: THPConfiguration,
        customOIDExternalUserAgent: OIDExternalUserAgent?
    ) {
        self.thpConfiguration = thpConfiguration
        self.customOIDExternalUserAgent = customOIDExternalUserAgent
        configureTIM(for: .signin)
    }
}

// MARK: - Input

extension TIMManagerEntity: TIMManager {
    
    // MARK: - Auth
    
    var refreshToken: JWT? {
        TIM.auth.refreshToken
    }
    
    var isLoggedIn: Bool {
        TIM.auth.isLoggedIn
    }
    
    func performOpenIDConnectFlow(flow: THPAuthenticationFlow, presentingViewController: UIViewController) -> AnyPublisher<JWT, THPError> {
        configureTIM(for: flow)
        return TIM.auth.performOpenIDConnectLogin(presentingViewController: presentingViewController)
            .mapError { $0.asTHPError() }
            .eraseToAnyPublisher()
    }
    
    func handleRedirect(url: URL) -> Bool {
        TIM.auth.handleRedirect(url: url)
    }
    
    func loginWithBiometricId(userId: String, storeNewRefreshToken: Bool) -> AnyPublisher<JWT, THPError> {
        TIM.auth.loginWithBiometricId(userId: userId, storeNewRefreshToken: storeNewRefreshToken, willBeginNetworkRequests: nil)
            .mapError { $0.asTHPError() }
            .eraseToAnyPublisher()
    }
    
    func loginWithPassword(userId: String, password: String, storeNewRefreshToken: Bool) -> AnyPublisher<JWT, THPError> {
        TIM.auth.loginWithPassword(userId: userId, password: password, storeNewRefreshToken: storeNewRefreshToken)
            .mapError { $0.asTHPError() }
            .eraseToAnyPublisher()
    }
    
    func clearAllUsers(except userId: String?) {
        TIM.storage.clearAllUsers(exceptUserId: userId)
    }
    
    func accessToken(forceRefresh: Bool) -> AnyPublisher<JWT, THPError> {
        TIM.auth.accessToken(forceRefresh: forceRefresh)
            .mapError { $0.asTHPError() }
            .eraseToAnyPublisher()
    }
    
    func getStoredRefreshToken(userId: String, password: String) -> AnyPublisher<JWT, THPError> {
        TIM.storage.getStoredRefreshToken(userId: userId, password: password)
            .mapError { $0.asTHPError() }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Storage
    
    var userId: String? {
        TIM.storage.availableUserIds.first
    }
    
    func enableBiometricAccessForRefreshToken(password: String, userId: String) -> AnyPublisher<Void, THPError> {
        TIM.storage.enableBiometricAccessForRefreshToken(password: password, userId: userId)
            .mapError { $0.asTHPError() }
            .eraseToAnyPublisher()
    }
    
    func hasBiometricAccessForRefreshToken(userId: String) -> Bool {
        TIM.storage.hasBiometricAccessForRefreshToken(userId: userId)
    }
    
    func disableBiometricAccessForRefreshToken(userId: String) {
        TIM.storage.disableBiometricAccessForRefreshToken(userId: userId)
    }
    
    func storeRefreshToken(_ refreshToken: THPJWT, withNewPassword newPassword: String) -> AnyPublisher<TIMESKeyCreationResult, THPError> {
        let timToken = JWT(token: refreshToken.token)! // TODO: Fix forceunwrap!
        return TIM.storage.storeRefreshToken(timToken, withNewPassword: newPassword)
            .mapError { $0.asTHPError() }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Mixed (for SDK simplicity)
    
    func logout(clearUser: Bool) {
        TIM.auth.logout()
        if clearUser {
            self.clearAllUsers(except: nil)
        }
    }
}

// MARK: - Helpers

extension TIMManagerEntity{
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
            allowReconfigure: true,
            customOIDExternalUserAgent: customOIDExternalUserAgent
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
