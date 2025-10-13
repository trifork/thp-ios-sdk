import Combine
import Foundation

public final actor THPUserStorageEntity: THPUserStorage {
    private let timManager: TIMManager
    
    init(timManager: TIMManager) {
        self.timManager = timManager
    }
   
    public var userId: String? {
        get async {
            await timManager.userId
        }
    }
    
    public func enableBiometricAccessForRefreshToken(password: String) async throws {
        guard let userId = await timManager.userId else {
            fatalError("You must have a logged in user to enable Biometrics")
        }
        try await timManager.enableBiometricAccessForRefreshToken(password: password, userId: userId)
    }
    
    public func hasBiometricAccessEnabled() async -> Bool {
        guard let userId = await timManager.userId else {
            fatalError("You must have a logged in user to call \(#function)")
        }
        return await timManager.hasBiometricAccessForRefreshToken(userId: userId)
    }
    
    public func disableBiometricAccess() async {
        guard let userId = await timManager.userId else {
            fatalError("You must have a logged in user to disable Biometrics")
        }
        await timManager.disableBiometricAccessForRefreshToken(userId: userId)
    }
    
    public func clearUser() async {
        await timManager.clearAllUsers(except: nil)
    }
    
    public func storeRefreshToken(_ refreshToken: THPJWT, withNewPassword newPassword: String) async throws {
        _ = try await timManager.storeRefreshToken(refreshToken, withNewPassword: newPassword)
    }
    
    public func getStoredRefreshToken(for userId: String, with password: String) async throws -> THPJWT {
        let jwt = try await timManager.getStoredRefreshToken(userId: userId, password: password)
        if let token = THPJWT(token: jwt.token) {
            return token
        } else {
            throw THPError.auth(.failedToGetRefreshToken)
        }
    }
}
