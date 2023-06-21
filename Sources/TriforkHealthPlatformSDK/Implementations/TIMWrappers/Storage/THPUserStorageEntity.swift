//
//  File.swift
//  
//
//  Created by Nicolai Harbo on 20/06/2023.
//

import Combine
import Foundation

public struct THPUserStorageEntity {
    
    private let timManager: TIMManager?
    
    init(timManager: TIMManager) {
        self.timManager = timManager
    }
}

extension THPUserStorageEntity: THPUserStorage {
   
    public var userId: String? {
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
        }
        return timManager.userId
    }
    
    public func enableBiometricAccessForRefreshToken(password: String) async throws -> Void {
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
        }
        
        guard let userId else {
            fatalError("You must have a logged in user to enable Biometrics")
        }
        
        var cancellable: AnyCancellable?
        return try await withCheckedThrowingContinuation { continuation in
            cancellable = timManager.enableBiometricAccessForRefreshToken(password: password, userId: userId)
                .sink(
                    receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    }, receiveValue: { _ in
                        continuation.resume()
                    }
                )
        }
    }
    
    public func hasBiometricAccessEnabled() -> Bool {
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
        }
        
        guard let userId else {
            fatalError("You must have a logged in user to call \(#function)")
        }
        return timManager.hasBiometricAccessForRefreshToken(userId: userId)
    }
    
    public func disableBiometricAccess() {
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
        }
        
        guard let userId else {
            fatalError("You must have a logged in user to disable Biometrics")
        }
        timManager.disableBiometricAccessForRefreshToken(userId: userId)
    }
    
    public func clearUser() {
        timManager?.clearAllUsers(except: nil)
    }
    
    public func storeRefreshToken(_ refreshToken: THPJWT, withNewPassword newPassword: String) async throws -> Void {
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
        }
        
        var cancellable: AnyCancellable?
        return try await withCheckedThrowingContinuation { continuation in
            cancellable = timManager.storeRefreshToken(refreshToken, withNewPassword: newPassword)
                .sink(
                    receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    }, receiveValue: { _ in
                        continuation.resume()
                    }
                )
        }
    }
    
    public func getStoredRefreshToken(for userId: String, with password: String) async throws -> THPJWT {
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
        }
        
        var cancellable: AnyCancellable?
        return try await withCheckedThrowingContinuation { continuation in
            cancellable = timManager.getStoredRefreshToken(userId: userId, password: password)
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
}
