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
    
    /// Handles redirect from the `SFSafariViewController`. The return value determines whether the URL was handled successfully.
    /// - Parameter url: The url that was directed to the app.
    @discardableResult
    func handleRedirect(url: URL) -> Bool
    
    /// Gets the current access token from the current session if available.
    /// This will automatically renew the access token if necessary (by using the refresh token)
    /// - Parameter forceRefresh: Force refresh an access token
    func getAccessToken(forceRefresh: Bool) async throws -> String
    
    /// Gets the refresh token from the current session if available
    var refreshToken: THPJWT? { get }
    
}
