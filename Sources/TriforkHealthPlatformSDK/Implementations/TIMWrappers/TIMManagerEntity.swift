import AppAuth
import Combine
import Foundation
import TIM
import TIMEncryptedStorage
import UIKit

public final actor TIMManagerEntity: TIMManager {
    private let thpConfiguration: THPConfiguration
    private let customOIDExternalUserAgent: THPOIDExternalUserAgent?
    
    public init(
        thpConfiguration: THPConfiguration,
        presentingViewController: UIViewController
    ) {
        self.thpConfiguration = thpConfiguration
        self.customOIDExternalUserAgent = THPOIDExternalUserAgent(presenting: presentingViewController)
    }
    
    // MARK: - Auth
    
    var refreshToken: JWT? {
        TIM.auth.refreshToken
    }
    
    var isLoggedIn: Bool {
        TIM.auth.isLoggedIn
    }
    
    func performOpenIDConnectFlow(flow: THPAuthenticationFlow, presentingViewController: UIViewController) async throws(THPError) -> JWT {
        configureTIM(for: flow)
        do {
            return try await TIM.auth.performOpenIDConnectLogin(presentingViewController: presentingViewController).value
        } catch {
            throw error.asTHPError()
        }
    }
    
    func performOpenIDConnectFlow(flow: THPAuthenticationFlow) async throws(THPError) -> JWT {
        configureTIM(for: flow)
        do {
            return try await TIM.auth.performOpenIDConnectLogin().value
        } catch {
            throw error.asTHPError()
        }
    }
    
    func handleRedirect(url: URL) -> Bool {
        TIM.auth.handleRedirect(url: url)
    }
    
    func loginWithBiometricId(userId: String, storeNewRefreshToken: Bool) async throws(THPError) -> JWT {
        do {
            return try await TIM.auth.loginWithBiometricId(userId: userId, storeNewRefreshToken: storeNewRefreshToken, willBeginNetworkRequests: nil).value
        } catch {
            throw error.asTHPError()
        }
    }
    
    func loginWithPassword(userId: String, password: String, storeNewRefreshToken: Bool) async throws(THPError) -> JWT {
        do {
            return try await TIM.auth.loginWithPassword(userId: userId, password: password, storeNewRefreshToken: storeNewRefreshToken).value
        } catch {
            throw error.asTHPError()
        }
    }
    
    func clearAllUsers(except userId: String?) {
        TIM.storage.clearAllUsers(exceptUserId: userId)
    }
    
    func accessToken(forceRefresh: Bool) async throws(THPError) -> JWT {
        do {
            return try await TIM.auth.accessToken(forceRefresh: forceRefresh).value
        } catch {
            throw error.asTHPError()
        }
    }
    
    func getStoredRefreshToken(userId: String, password: String) async throws(THPError) -> JWT {
        do {
            return try await TIM.storage.getStoredRefreshToken(userId: userId, password: password).value
        } catch {
            throw error.asTHPError()
        }
    }
    
    // MARK: - Storage
    
    var userId: String? {
        TIM.storage.availableUserIds.first
    }
    
    func enableBiometricAccessForRefreshToken(password: String, userId: String) async throws(THPError) {
        do {
            return try await TIM.storage.enableBiometricAccessForRefreshToken(password: password, userId: userId).value
        } catch {
            throw error.asTHPError()
        }
    }
    
    func hasBiometricAccessForRefreshToken(userId: String) -> Bool {
        TIM.storage.hasBiometricAccessForRefreshToken(userId: userId)
    }
    
    func disableBiometricAccessForRefreshToken(userId: String) {
        TIM.storage.disableBiometricAccessForRefreshToken(userId: userId)
    }
    
    func storeRefreshToken(_ refreshToken: THPJWT, withNewPassword newPassword: String) async throws(THPError) -> TIMESKeyCreationResult {
        guard let timToken = JWT(token: refreshToken.token) else {
            throw THPError.auth(THPAuthError.failedToGetRefreshToken)
        }
        do {
            return try await TIM.storage.storeRefreshToken(timToken, withNewPassword: newPassword).value
        } catch {
            throw error.asTHPError()
        }
    }
    
    // MARK: - Mixed (for SDK simplicity)
    
    func logout(clearUser: Bool) {
        TIM.auth.logout()
        if clearUser {
            clearAllUsers(except: nil)
        }
    }
}

// MARK: - Helpers

extension JWT: @unchecked @retroactive Sendable {}
extension Future: @unchecked @retroactive Sendable {}
extension TIMESKeyCreationResult: @unchecked @retroactive Sendable {}

extension TIMManagerEntity{
    func configureTIM(for flow: THPAuthenticationFlow) {
        TIM.configure(
            configuration: TIMConfiguration(
                timBaseUrl: thpConfiguration.baseAuthURL,
                realm: thpConfiguration.realm,
                clientId: thpConfiguration.clientId,
                redirectUri: URL(string: thpConfiguration.redirectUrl)!,
                scopes: thpConfiguration.scopes,
                encryptionMethod: .aesGcm,
                additionalParameters: [
                    "ui_locales": Locale.applicationLocale.identifier.split(separator: "-")[0].description,
                    "prompt": "login",
                    thpConfiguration.loginFlowKey: flow.rawValue
                ]
            ),
            allowReconfigure: true,
            customOIDExternalUserAgent: customOIDExternalUserAgent
        )
    }
}
