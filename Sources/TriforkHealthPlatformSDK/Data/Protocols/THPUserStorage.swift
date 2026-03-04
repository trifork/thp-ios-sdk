import Foundation
import TIM

public protocol THPUserStorage: Actor {
    /// The current users userId
    var userId: String? { get async }
    
    /// Enables biometric protection access for refresh token.
    /// - Parameters:
    ///   - password: The password that was used to store the refresh token.
    ///   - userId: The `userId` for the refresh token.
    func enableBiometricAccessForRefreshToken(password: String) async throws(THPError)
    
    /// Checks whether the logged in user has stored a refresh token with biometric protection access.
    func hasBiometricAccessEnabled() async throws(THPError) -> Bool
    
    /// Disables biometric protection access for refresh token.
    func disableBiometricAccess() async throws(THPError)
    
    ///  Clears all securely stored data for the logged in user
    func clearUser() async
    
    /// Stores refresh token with a new password and removes current biometric access for potential previous refresh token.
    /// - Parameters:
    ///   - refreshToken: The refresh token.
    ///   - newPassword: The new password that needs a new encryption key.
    func storeRefreshToken(_ refreshToken: THPJWT, withNewPassword newPassword: String) async throws(THPError)
    
    /// Gets a stored refresh token for a `userId` and a `password`
    /// - Parameters:
    ///   - userId: The `userId` from the refresh token
    ///   - password: The password that was used to store it.
    func getStoredRefreshToken(for userId: String, with password: String) async throws(THPError) -> THPJWT
}
