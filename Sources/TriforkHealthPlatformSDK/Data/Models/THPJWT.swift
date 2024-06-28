//
//  File.swift
//
//
//  Created by Nicolai Harbo on 20/06/2023.
//

import Foundation

/// Wrapper class for a `THPJWTString`. This class is used to guarantee that a token always is accompanied with a valid userId and expire timestamp.
public struct THPJWT {
    /// JWT token
    public let token: String

    /// User ID from token's `sub` parameter
    public let userId: String

    /// The expiration date from the `exp` parameter
    /// This value is optional, since isn't required on refresh tokens.
    public let expireDate: Date?

    /// The value of the `iss` parameter.
    /// This value is optional.
    public let issuer: String?

    /// Failable initializer for `JWT`.
    /// This will only succeed if the token contains a `sub` parameter.
    public init?(token: String) {
        self.token = token
        if let userId = token.userId {
            self.userId = userId
        } else {
            return nil
        }

        if let expireTimestamp = token.expireTimestamp {
            self.expireDate = Date(timeIntervalSince1970: expireTimestamp)
        } else {
            self.expireDate = nil
        }
        self.issuer = token.issuer
    }
}
