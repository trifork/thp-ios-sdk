
/// Main entrypoint for the SDK
public final class THP {
    
    /// The shared instance of the `TriforkHealthPlatformSDK` which should be used for all interactions.
    public static var shared: THP = THP()
    
    // Singleton init
    private init() { }
    
    // MARK: - Private properties
    private var timManager: TIMManager?
    private var _auth: THPAuth?
    private var _userStorage: THPUserStorage?
}

// MARK: - Input

extension THP {
    /// Configures the `TriforkHealthPlatformSDK`
    /// The configuration needs to be called before any other functionalities can be used
    /// You should only call this function once.
    /// - Parameter configuration: The actual configuration
    public func configure(configuration: THPConfiguration) {
        timManager = TIMManagerEntity(thpConfiguration: configuration)
        _auth = THPAuthEntity(timManager: timManager!)
    }
    
    /// Gives you access to the auth features of the SDK.
    public var auth: THPAuth {
        if let authInstance = _auth {
            return authInstance
        } else {
            fatalError("You have to call the `configure(configuration:)` method before using `\(#function)`")
        }
    }
    
    /// Gives you access to the user storage features of the SDK.
    public var userStorage: THPUserStorage {
        if let storageInstance = _userStorage {
            return storageInstance
        } else {
            fatalError("You have to call the `configure(configuration:)` method before using `\(#function)`")
        }
    }
}
