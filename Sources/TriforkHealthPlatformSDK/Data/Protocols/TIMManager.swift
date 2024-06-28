//
//  File.swift
//  
//
//  Created by Nicolai Harbo on 20/06/2023.
//

import Combine
import Foundation
import TIM
import TIMEncryptedStorage
import UIKit

protocol TIMManager {
    
    // MARK: - Auth
    
    func performOpenIDConnectFlow(flow: THPAuthenticationFlow, presentingViewController: UIViewController) -> AnyPublisher<JWT, THPError>
    func performOpenIDConnectFlow(flow: THPAuthenticationFlow) -> AnyPublisher<JWT, THPError>
    @discardableResult
    func handleRedirect(url: URL) -> Bool
    func loginWithBiometricId(userId: String, storeNewRefreshToken: Bool) -> AnyPublisher<JWT, THPError>
    func loginWithPassword(userId: String, password: String, storeNewRefreshToken: Bool) -> AnyPublisher<JWT, THPError>
    func clearAllUsers(except userId: String?)
    func accessToken(forceRefresh: Bool) -> AnyPublisher<JWT, THPError>
    func getStoredRefreshToken(userId: String, password: String) -> AnyPublisher<JWT, THPError>
    var refreshToken: JWT? { get }
    var isLoggedIn: Bool { get }
    
    // MARK: - Storage
    
    var userId: String? { get }
    func enableBiometricAccessForRefreshToken(password: String, userId: String) -> AnyPublisher<Void, THPError>
    func hasBiometricAccessForRefreshToken(userId: String) -> Bool
    func disableBiometricAccessForRefreshToken(userId: String)
    func storeRefreshToken(_ refreshToken: THPJWT, withNewPassword newPassword: String) -> AnyPublisher<TIMESKeyCreationResult, THPError>
    
    // MARK: - Mixed (for SDK simplicity)
    
    func logout(clearUser: Bool)
}
