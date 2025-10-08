import Foundation
import TIM
import TIMEncryptedStorage

public typealias THPAuthError = TIMAuthError
public typealias THPStorageError = TIMStorageError
public typealias THPEncryptedStorageError = TIMEncryptedStorageError

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

    public var errorDescription: String? {
        switch self {
        case .auth(let error):
            error.localizedDescription
        case .storage(let error):
            error.localizedDescription
        }
    }
}
