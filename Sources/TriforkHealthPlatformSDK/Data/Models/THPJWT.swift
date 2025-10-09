import Foundation

/// Wrapper class for a `THPJWTString`. This class is used to guarantee that a token always is accompanied with a valid userId and expire timestamp.
public struct THPJWT: Sendable {
    /// Original JWT token, as retrieved for the identity provider.
    public let token: String

    /// User ID from token's `sub` parameter
    public let userId: String

    /// The expiration date from the `exp` parameter
    /// This value is optional, since isn't required on refresh tokens.
    public let expireDate: Date?

    /// The value of the `iss` parameter.
    /// This value is optional.
    public let issuer: String?

    /// The value of the `login_provider` parameter.
    /// This value is optional
    public let loginProvider: String?
}

extension THPJWT {
    /// Failable initializer for `THPJWT`.
    /// This will only succeed if the token contains a `sub` parameter.
    public init?(token: String) {
        let parsedToken = THPJWTDecoder.decode(jwtToken: token)
        guard let userId = parsedToken.userId else { return nil }
        self.init(
            token: token,
            userId: userId,
            expireDate: parsedToken.expireTimestamp.map { Date(timeIntervalSince1970: $0) },
            issuer: parsedToken.issuer,
            loginProvider: parsedToken.loginProvider
        )
    }

    }
}
