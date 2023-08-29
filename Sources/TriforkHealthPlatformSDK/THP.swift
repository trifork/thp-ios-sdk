import AppAuth

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
    private var _configuration: THPConfiguration?
}

// MARK: - Input

extension THP {
    /// Configures the `TriforkHealthPlatformSDK`
    /// The configuration needs to be called before any other functionalities can be used
    /// You should only call this function once.
    /// - Parameter configuration: The actual configuration
    /// - Parameter customOIDExternalUserAgent: The actual configuration
    public func configure(
        configuration: THPConfiguration,
        customOIDExternalUserAgent: OIDExternalUserAgent? = nil
    ) {
        timManager = TIMManagerEntity(
            thpConfiguration: configuration,
            customOIDExternalUserAgent: customOIDExternalUserAgent
        )
        _auth = THPAuthEntity(timManager: timManager!)
        _userStorage = THPUserStorageEntity(timManager: timManager!)
        _configuration = configuration
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
    
    /// Allows you to read the configuration
    public var configuration: THPConfiguration? {
        return _configuration
    }
    
//    /// Gives you access to medical data for the logged in user
//    public var data: THPData {
//        if let dataInstance = _data {
//            return dataInstance
//        } else {
//            fatalError("You have to call the `configure(configuration:)` method before using `\(#function)`")
//        }
//    }
}


// TODO: Tasks that needs to be done
// - Add documentation for the THPConfiguration file
// - Add documentation in Github Readme, on how to use the SDK for logging in/signing up.
// - Set up Apollo to prepare for handling data, when BFF is ready to deliver data instaed of view components
