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
    
    public func enableBiometricAccessForRefreshToken(password: String, userId: String) async throws -> Void {
        guard let timManager else {
            fatalError("You have to call the `configure(configuration:)` method before using \(#function)")
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
    
    public func clearAllUsers(exceptUserId: String? = nil) {
        timManager?.clearAllUsers(except: exceptUserId)
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
}
