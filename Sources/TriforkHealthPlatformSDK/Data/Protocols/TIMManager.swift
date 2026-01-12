import TIM
import TIMEncryptedStorage
import UIKit

protocol TIMManager: Actor {
    // MARK: - Auth
    
    func performOpenIDConnectFlow(flow: THPAuthenticationFlow, presentingViewController: UIViewController) async throws(THPError) -> JWT
    func performOpenIDConnectFlow(flow: THPAuthenticationFlow) async throws(THPError) -> JWT
    @discardableResult
    func handleRedirect(url: URL) -> Bool
    func loginWithBiometricId(userId: String, storeNewRefreshToken: Bool) async throws(THPError) -> JWT
    func loginWithPassword(userId: String, password: String, storeNewRefreshToken: Bool) async throws(THPError) -> JWT
    func clearAllUsers(except userId: String?)
    func accessToken(forceRefresh: Bool) async throws(THPError) -> JWT
    func getStoredRefreshToken(userId: String, password: String) async throws(THPError) -> JWT
    var refreshToken: JWT? { get }
    var isLoggedIn: Bool { get }
    
    // MARK: - Storage
    
    var userId: String? { get }
    func enableBiometricAccessForRefreshToken(password: String, userId: String) async throws(THPError) -> Void
    func hasBiometricAccessForRefreshToken(userId: String) -> Bool
    func disableBiometricAccessForRefreshToken(userId: String)
    func storeRefreshToken(_ refreshToken: THPJWT, withNewPassword newPassword: String) async throws(THPError) -> TIMESKeyCreationResult
    
    // MARK: - Mixed (for SDK simplicity)
    
    func logout(clearUser: Bool)
}
