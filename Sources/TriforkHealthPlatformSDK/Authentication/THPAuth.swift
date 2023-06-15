//
//  THPAuth.swift
//  
//
//  Created by Nicolai Harbo on 15/06/2023.
//

import Combine
import Foundation
import UIKit

public struct THPAuth {
    
    private let timManager: TIMManagerProtocol?
    
    init(timManager: TIMManagerProtocol) {
        self.timManager = timManager
    }
    
    /// Performs OAuth login or signup with OpenID Connect by presenting a `SFSafariViewController` on the `presentingViewController`
    ///
    /// The `refreshToken` property will be available after this, which can be used to encrypt and store it in the secure store by the `storage` namespace.
    /// - Parameters:
    ///   - flow: .signin or .signup, depending on which flow you want to run
    ///   - presentingViewController: The view controller which the safari view controller should be presented on.
    /// - Returns: The userId is returned in String format.
    func performOpenIDConnectFlow(
        flow: THPAuthenticationFlow,
        presentingViewController: UIViewController
    ) async throws -> String {
        
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
        }
        var cancellable: AnyCancellable?
        var userId: String?
        
        return try await withCheckedThrowingContinuation { continuation in
            cancellable = timManager.performOpenIDConnectFlow(flow: flow, presentingViewController: presentingViewController)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                        
                    case .finished:
                        guard let userId else {
                            continuation.resume(throwing: THPAuthError.auth(.authStateNil))
                            return
                        }
                        
                        // New login succeeded. Since we only support one user login we will clear all other ids on this device.
                        timManager.clearAllUsers(except: userId)
                        continuation.resume(returning: userId)
                    }
                    cancellable?.cancel()
                } receiveValue: { accessToken in
                    userId = accessToken.userId
                }
        }
    }
    
    @discardableResult
    func handleRedirect(url: URL) -> Bool {
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
        }
        return timManager.handleRedirect(url: url)
    }
}
