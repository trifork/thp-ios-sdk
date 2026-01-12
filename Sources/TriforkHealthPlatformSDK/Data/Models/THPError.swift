import Foundation
import TIM
import TIMEncryptedStorage

public typealias THPAuthError = TIMAuthError
public typealias THPStorageError = TIMStorageError
public typealias THPEncryptedStorageError = TIMEncryptedStorageError

extension Error {
    func asTHPError() -> THPError {
        guard let timError = self as? TIMError else {
            return .unknown
        }
        return timError.asTHPError()
    }
}

extension TIMError {
    func asTHPError() -> THPError {
        switch self {
        case .auth(let error):
            .auth(error)
        case .storage(let error):
            .storage(error)
        }
    }
}

public enum THPError: Error {
    case auth(THPAuthError)
    case storage(THPStorageError)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .auth(let error):
            error.localizedDescription
        case .storage(let error):
            error.localizedDescription
        case .unknown:
            "An unexpected error occurred that cannot be identified."
        }
    }
}
