import Foundation

/// Type alias for tokens - just a string.
public typealias THPJWTString = String

public typealias THPJWTDecoded = [String: Any]

extension THPJWTDecoded {
    private enum Key {
        static let expireDate: String = "exp"
        static let userId: String = "sub"
        static let issuer: String = "iss"
        static let loginProvider: String = "login_provider"
    }
    
    /// `exp` value
    var expireTimestamp: TimeInterval? {
        self[THPJWTDecoded.Key.expireDate] as? TimeInterval
    }

    /// `sub` value
    var userId: String? {
        self[THPJWTDecoded.Key.userId] as? String
    }

    /// `iss` value
    var issuer: String? {
        self[THPJWTDecoded.Key.issuer] as? String
    }

    /// `login_provider` value
    var loginProvider: String? {
        self[THPJWTDecoded.Key.loginProvider] as? String
    }
}
