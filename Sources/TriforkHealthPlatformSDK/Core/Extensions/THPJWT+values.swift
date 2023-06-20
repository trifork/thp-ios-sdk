//
//  File.swift
//
//
//  Created by Nicolai Harbo on 20/06/2023.
//

import Foundation

private let EXPIRE_KEY: String = "exp"
private let SUB_KEY: String = "sub"
private let ISSUER_KEY: String = "iss"

/// Type alias for tokens - just a string.
public typealias THPJWTString = String

/// Extensions for default data on a JWT.
extension THPJWTString {

    /// `exp` value
    var expireTimestamp: TimeInterval? {
        THPJWTDecoder.decode(jwtToken: self)[EXPIRE_KEY] as? TimeInterval
    }

    /// `sub` value
    var userId: String? {
        THPJWTDecoder.decode(jwtToken: self)[SUB_KEY] as? String
    }

    /// `iss` value
    var issuer: String? {
        THPJWTDecoder.decode(jwtToken: self)[ISSUER_KEY] as? String
    }
}
