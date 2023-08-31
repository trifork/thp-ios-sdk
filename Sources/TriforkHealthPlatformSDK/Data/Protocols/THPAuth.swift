//
//  THPAuthProtocol.swift
//  
//
//  Created by Nicolai Harbo on 20/06/2023.
//

import TIM
import UIKit

public protocol THPAuth {
    /// Performs OAuth login or signup with OpenID Connect by presenting a `SFSafariViewController` on the `presentingViewController`
    ///
    /// The `refreshToken` property will be available after this, which can be used to encrypt and store it in the secure store by the `storage` namespace.
    /// - Parameters:
    ///   - flow: .signin or .signup, depending on which flow you want to run
    ///   - presentingViewController: The view controller which the safari view controller should be presented on.
    /// - Returns: The userId is returned in String format.
    func performOpenIDConnectFlow(flow: THPAuthenticationFlow, presentingViewController: UIViewController) async throws -> String
    
    /// Performs OAuth login or signup with OpenID Connect. The url will be prepared and returned in a NSNotification, for you to present in a custom view.
    ///
    /// The `refreshToken` property will be available after this, which can be used to encrypt and store it in the secure store by the `storage` namespace.
    /// - Parameters:
    ///   - flow: .signin or .signup, depending on which flow you want to run
    /// - Returns: The userId is returned in String format.
    func performOpenIDConnectFlow(flow: THPAuthenticationFlow) async throws -> String
    
    /// Handles redirect from the `SFSafariViewController`. The return value determines whether the URL was handled successfully.
    /// - Parameter url: The url that was directed to the app.
    @discardableResult
    func handleRedirect(url: URL) -> Bool
    
    /// Logs in using biometric login. This can only be done if the user has stored the refresh token with a password after calling `performOpenIDConnectLogin` AND enabled biometric protection for it.
    /// - Parameters:
    ///   - storeNewRefreshToken: `true` if it should store the new refresh token, and `false` if not. Most people will need this as `true`
    func loginWithBiometricId(storeNewRefreshToken: Bool) async throws -> THPJWT
    
    /// Gets the current access token (JWT) from the current session if available.
    /// This will automatically renew the access token if necessary (by using the refresh token)
    /// - Parameter forceRefresh: Force refresh an access token
    func getAccessToken(forceRefresh: Bool) async throws -> THPJWT
    
    /// Logs in using password. This can only be done if the user has stored the refresh token with a password after calling `performOpenIDConnectLogin`.
    /// - Parameters:
    ///   - password: The password that was used when the refresh token was stored.
    ///   - storeNewRefreshToken: `true` if it should store the new refresh token, and `false` if not. Most people will need this as `true`
    func loginWithPassword(password: String, storeNewRefreshToken: Bool) async throws -> THPJWT
    
    /// Logs out the user of the current session, clearing the auth state with active tokens
    /// - Parameter clearUser: Clears all securely stored data
    func logout(clearUser: Bool)
    
    /// Gets the refresh token (JWT) from the current session if available
    var refreshToken: THPJWT? { get }
    
    /// Indicates whether the user as a valid auth state
    var isLoggedIn: Bool { get }
}
