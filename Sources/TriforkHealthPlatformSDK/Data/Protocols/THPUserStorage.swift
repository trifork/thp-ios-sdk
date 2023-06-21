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
    func enableBiometricAccessForRefreshToken(password: String) async throws -> Void
    
    /// Checks whether the logged in user has stored a refresh token with biometric protection access.
    func hasBiometricAccessEnabled() -> Bool
    
    /// Disables biometric protection access for refresh token.
    func disableBiometricAccess()
    
    ///  Clears all securely stored data for the logged in user
    func clearUser()
    
    /// Stores refresh token with a new password and removes current biometric access for potential previous refresh token.
    /// - Parameters:
    ///   - refreshToken: The refresh token.
    ///   - newPassword: The new password that needs a new encryption key.
    func storeRefreshToken(_ refreshToken: THPJWT, withNewPassword newPassword: String) async throws -> Void
}
