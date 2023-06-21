//
//  THPAuth.swift
//  
//
//  Created by Nicolai Harbo on 15/06/2023.
//

import Combine
import Foundation
import UIKit

public struct THPAuthEntity {
    
    private let timManager: TIMManager?
    
    init(timManager: TIMManager) {
        self.timManager = timManager
    }
}

extension THPAuthEntity: THPAuth {
    
    public func performOpenIDConnectFlow(
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
                            continuation.resume(throwing: THPError.auth(.authStateNil))
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
    public func handleRedirect(url: URL) -> Bool {
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
        }
        return timManager.handleRedirect(url: url)
    }
    
    public func loginWithBiometricId(storeNewRefreshToken: Bool) async throws -> THPJWT {
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
        }
        
        guard let userId = timManager.userId else {
            fatalError("userId is missing!")
        }
        
        var cancellable: AnyCancellable?
        return try await withCheckedThrowingContinuation { continuation in
            cancellable = timManager.loginWithBiometricId(userId: userId, storeNewRefreshToken: storeNewRefreshToken)
                .mapError { $0 }
                .sink(
                    receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    }, receiveValue: { accessToken in
                        continuation.resume(returning: THPJWT(token: accessToken.token)!)
                    }
                )
        }
    }
    
    public func loginWithPassword(password: String, storeNewRefreshToken: Bool) async throws -> THPJWT {
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
        }
        
        guard let userId = timManager.userId else {
            fatalError("userId is missing!")
        }
        
        var cancellable: AnyCancellable?
        return try await withCheckedThrowingContinuation { continuation in
            cancellable = timManager.loginWithPassword(userId: userId, password: password, storeNewRefreshToken: storeNewRefreshToken)
                .mapError { $0 }
                .sink(
                    receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    }, receiveValue: { accessToken in
                        continuation.resume(returning: THPJWT(token: accessToken.token)!)
                    }
                )
        }
    }
    
    public func getAccessToken(forceRefresh: Bool = false) async throws -> THPJWT {
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
        }
        
        var cancellable: AnyCancellable?
        return try await withCheckedThrowingContinuation { continuation in
            cancellable = timManager.accessToken(forceRefresh: forceRefresh)
                .mapError { $0 }
                .sink(
                    receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    }, receiveValue: { accessToken in
                        continuation.resume(returning: THPJWT(token: accessToken.token)!)
                    }
                )
        }
    }
    
    public var refreshToken: THPJWT? {
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
        }
        guard let token = timManager.refreshToken?.token else { return nil }
        return THPJWT(token: token)
    }
    
    public func logout(clearUser: Bool) {
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
        }
        timManager.logout(clearUser: clearUser)
    }
    
    public var isLoggedIn: Bool {
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
        }
        return timManager.isLoggedIn
    }
}
