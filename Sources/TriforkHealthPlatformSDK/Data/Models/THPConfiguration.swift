import Foundation
import TIM

public struct THPConfiguration: Sendable {
    public let baseAuthURL: URL
    public let scopes: [String]
    public let realm: String
    public let clientId: String
    public let redirectUrl: String
    public let loginFlowKey: String
    public let additionalParameters: [String: String]

    /// Default constructor
    /// - Parameters:
    ///   - scopes: Scopes, e.g. `["scope"]`
    ///   - realm: Realm, e.g. `"my-test-realm"`
    ///   - clientId: Client Id, e.g. `"my-client"`
    ///   - redirectUrl: Redirect URL, e.g. `"my-app:/"`
    ///   - baseAuthURL: Base base URL to authenticate, e.g. https://trifork.com
    ///   - loginFlowKey: The client app key to identify the login flow source, e.g. `"client-flow"`
    ///   - additionalParameters: Additional configuration parameters, such as the prompt or the locale for the UI.
    public init(
        scopes: [String],
        realm: String,
        clientId: String,
        redirectUrl: String,
        baseAuthURL: URL,
        loginFlowKey: String,
        additionalParameters: [String: String]
    ) {
        self.scopes = scopes
        self.realm = realm
        self.clientId = clientId
        self.redirectUrl = redirectUrl
        self.baseAuthURL = baseAuthURL
        self.loginFlowKey = loginFlowKey
        self.additionalParameters = additionalParameters
    }
}
