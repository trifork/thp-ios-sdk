
/// Main entrypoint for the SDK
public final class THPEntity {
    
    /// The shared instance of the `TriforkHealthPlatformSDK` which should be used for all interactions.
    public static var shared: THPEntity = THPEntity()
    
    // Singleton init
    private init() { }
    
    // MARK: - Private properties
    private var timManager: TIMManager?
    private var _auth: THPAuth?
}

// MARK: - Input

extension THPEntity: THP {
    public func configure(configuration: THPConfiguration) {
        timManager = TIMManagerEntity(thpConfiguration: configuration)
        _auth = THPAuthEntity(timManager: timManager!)
    }
    
    public var auth: THPAuth {
        if let authInstance = _auth {
            return authInstance
        } else {
            fatalError("You have to call the `configure(configuration:)` method before using `\(#function)`")
        }
    }
}
