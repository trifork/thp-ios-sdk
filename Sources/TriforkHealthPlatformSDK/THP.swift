/// Main entrypoint for the SDK
public final actor THP {
    
    /// The shared instance of the `TriforkHealthPlatformSDK` which should be used for all interactions.
    public static let shared: THP = THP()
    
    /// Singleton init
    private init() { }
    
    // MARK: - Private properties
    private var timManager: TIMManager?
    private var _auth: THPAuth?
    private var _userStorage: THPUserStorage?
    
    // MARK: - Public non-modifiable properties
    private(set) public var configuration: THPConfiguration?

    /// Configures the `TriforkHealthPlatformSDK`
    /// The configuration needs to be called before any other functionalities can be used
    /// You should only call this function once.
    /// - Parameter configuration: The actual configuration
    public func configure(_ configuration: THPConfiguration) async {
        let timManager = await TIMManagerEntity(
            thpConfiguration: configuration,
            presentingViewController: .init()
        )
        await timManager.configureTIM(for: .signin)
        self.configuration = configuration
        self.timManager = timManager
        _auth = THPAuthEntity(timManager: timManager)
        _userStorage = THPUserStorageEntity(timManager: timManager)
    }
    
    /// Gives you access to the auth features of the SDK.
    public var auth: THPAuth {
        if let _auth {
            return _auth
        } else {
            fatalError("You have to call the `configure(_ configuration:)` method before using `\(#function)`")
        }
    }
    
    /// Gives you access to the user storage features of the SDK.
    public var userStorage: THPUserStorage {
        if let _userStorage {
            return _userStorage
        } else {
            fatalError("You have to call the `configure(_ configuration:)` method before using `\(#function)`")
        }
    }
}


// TODO: Tasks that needs to be done
// - Add documentation for the THPConfiguration file
// - Add documentation in Github Readme, on how to use the SDK for logging in/signing up.
// - Set up Apollo to prepare for handling data, when BFF is ready to deliver data instaed of view components
