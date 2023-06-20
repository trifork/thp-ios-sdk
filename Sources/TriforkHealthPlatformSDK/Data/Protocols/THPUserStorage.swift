//
//  THPUserStorageProtocol.swift
//  
//
//  Created by Nicolai Harbo on 20/06/2023.
//

import Foundation
import TIM

public protocol THPUserStorage {
    /// The current users userId
    var userId: String? { get }
    
    /// Enables biometric protection access for refresh token.
    /// - Parameters:
    ///   - password: The password that was used to store the refresh token.
    ///   - userId: The `userId` for the refresh token.
    func enableBiometricAccessForRefreshToken(password: String, userId: String) async throws -> Void
    
    
    /// Clears all stored users
    /// - Parameter exceptUserId: Optional `userId` of the only user you don't want to clear, if any
    func clearAllUsers(exceptUserId: String?)
    
    /// Stores refresh token with a new password and removes current biometric access for potential previous refresh token.
    /// - Parameters:
    ///   - refreshToken: The refresh token.
    ///   - newPassword: The new password that needs a new encryption key.
    func storeRefreshToken(_ refreshToken: THPJWT, withNewPassword newPassword: String) async throws -> Void
}
