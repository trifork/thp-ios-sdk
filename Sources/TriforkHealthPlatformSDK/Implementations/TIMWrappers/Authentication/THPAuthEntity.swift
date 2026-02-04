import Foundation
import UIKit

public final actor THPAuthEntity: THPAuth {
    private let timManager: TIMManager
    
    init(timManager: TIMManager) {
        self.timManager = timManager
    }
    
    public func performOpenIDConnectFlow(
        flow: THPAuthenticationFlow,
        presentingViewController: UIViewController
    ) async throws(THPError) -> String {
        try await timManager.performOpenIDConnectFlow(flow: flow, presentingViewController: presentingViewController).userId
    }
    
    public func performOpenIDConnectFlow(flow: THPAuthenticationFlow) async throws(THPError) -> String {
        try await timManager.performOpenIDConnectFlow(flow: flow).userId
    }
    
    @discardableResult
    public func handleRedirect(url: URL) async -> Bool {
        await timManager.handleRedirect(url: url)
    }
    
    public func loginWithBiometricId(storeNewRefreshToken: Bool) async throws(THPError) -> THPJWT {
        guard let userId = await timManager.userId else {
            fatalError("userId is missing!")
        }
        
        let result = try await timManager.loginWithBiometricId(userId: userId, storeNewRefreshToken: storeNewRefreshToken)
        if let token = THPJWT(token: result.token) {
            return token
        } else {
            throw .auth(.failedToValidateIDToken)
        }
    }
    
    public func loginWithPassword(password: String, storeNewRefreshToken: Bool) async throws(THPError) -> THPJWT {
        guard let userId = await timManager.userId else {
            fatalError("userId is missing!")
        }
        
        let result = try await timManager.loginWithPassword(userId: userId, password: password, storeNewRefreshToken: storeNewRefreshToken)
        if let token = THPJWT(token: result.token) {
            return token
        } else {
            throw .auth(.failedToValidateIDToken)
        }
    }
    
    public func getAccessToken(forceRefresh: Bool = false) async throws(THPError) -> THPJWT {
        let result = try await timManager.accessToken(forceRefresh: forceRefresh)
        if let token = THPJWT(token: result.token) {
            return token
        } else {
            throw .auth(.failedToValidateIDToken)
        }
    }

    public func logout(clearUser: Bool) async {
        await timManager.logout(clearUser: clearUser)
    }
    
    public var refreshToken: THPJWT? {
        get async {
            guard let token = await timManager.refreshToken?.token else { return nil }
            return THPJWT(token: token)
        }
    }
    
    public var isLoggedIn: Bool {
        get async {
            await timManager.isLoggedIn
        }
    }
}
