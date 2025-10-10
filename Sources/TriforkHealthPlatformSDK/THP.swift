/// Main entrypoint for the SDK
public final actor THP {
    
    /// The shared instance of the `TriforkHealthPlatformSDK` which should be used for all interactions.
    public static let shared: THP = THP()
    
    /// Singleton init
    private init() { }
    
    /// Default initializer
    /// - parameter configuration:
    public init(configuration: THPConfiguration) {
        self.init()
        Task { await configure(configuration) }
    }
    
    // MARK: - Private properties
    private var timManager: TIMManager?
    private var _auth: THPAuth?
    private var _userStorage: THPUserStorage?
    
    // MARK: - Public non-modifiable properties
    private(set) public var configuration: THPConfiguration?
    private(set) public var isConfigured: Bool = false

    /// Configures the `TriforkHealthPlatformSDK`
    /// The configuration needs to be called before any other functionalities can be used
    /// You should only call this function once.
    /// - Parameter configuration: The actual configuration
    public func configure(_ configuration: THPConfiguration) async {
        isConfigured = false
        let timManager = await TIMManagerEntity(
            thpConfiguration: configuration,
            presentingViewController: .init()
        )
        await timManager.configureTIM(for: .signin)
        self.configuration = configuration
        self.timManager = timManager
        _auth = THPAuthEntity(timManager: timManager)
        _userStorage = THPUserStorageEntity(timManager: timManager)
        isConfigured = true
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
