import TIM
import TIMEncryptedStorage
import UIKit

protocol TIMManager: Actor {
    // MARK: - Auth
    
    func performOpenIDConnectFlow(flow: THPAuthenticationFlow, presentingViewController: UIViewController) async throws -> JWT
    func performOpenIDConnectFlow(flow: THPAuthenticationFlow) async throws -> JWT
    @discardableResult 
    func handleRedirect(url: URL) -> Bool
    func loginWithBiometricId(userId: String, storeNewRefreshToken: Bool) async throws -> JWT
    func loginWithPassword(userId: String, password: String, storeNewRefreshToken: Bool) async throws -> JWT
    func clearAllUsers(except userId: String?)
    func accessToken(forceRefresh: Bool) async throws -> JWT
    func getStoredRefreshToken(userId: String, password: String) async throws -> JWT
    var refreshToken: JWT? { get }
    var isLoggedIn: Bool { get }
    
    // MARK: - Storage
    
    var userId: String? { get }
    func enableBiometricAccessForRefreshToken(password: String, userId: String) async throws -> Void
    func hasBiometricAccessForRefreshToken(userId: String) -> Bool
    func disableBiometricAccessForRefreshToken(userId: String)
    func storeRefreshToken(_ refreshToken: THPJWT, withNewPassword newPassword: String) async throws -> TIMESKeyCreationResult
    
    // MARK: - Mixed (for SDK simplicity)
    
    func logout(clearUser: Bool)
}
