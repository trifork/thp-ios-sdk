//
//  File.swift
//  
//
//  Created by Nicolai Harbo on 20/06/2023.
//

import Foundation
import TIM

public typealias THPAuthError = TIMAuthError
public typealias THPStorageError = TIMStorageError

extension TIMError {
    func asTHPError() -> THPError {
        switch self {
        case .auth(let error):
            return .auth(error)
        case .storage(let error):
            return .storage(error)
        }
    }
}

public enum THPError: Error {
    case auth(THPAuthError)
    case storage(THPStorageError)

    public var errorDescription: String? {
        switch self {
        case .auth(let error):
            return error.localizedDescription
        case .storage(let error):
            return error.localizedDescription
        }
    }
}
