
/// Main entrypoint for the SDK
public final class THP {
    
    public static var shared: THP = THP()
    
    
    private init() { }
    
    // MARK: - Private properties
    private var timManager: TIMManager?
    private var _auth: THPAuth?
}

// MARK: - Input

public extension THP {
    func configure(configuration: THPConfiguration) {
        timManager = TIMManager(thpConfiguration: configuration)
        _auth = THPAuth(timManager: timManager!)
    }
    
    var auth: THPAuth {
        if let authInstance = _auth {
            return authInstance
        } else {
            fatalError("You have to call the `configure(configuration:)` method before using TIM.auth!")
        }
    }
}
