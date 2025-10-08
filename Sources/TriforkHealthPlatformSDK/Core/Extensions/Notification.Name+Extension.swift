import Foundation

public extension Notification.Name {
    static let thpOIDCPresentationNotification = Notification.Name("ThpOidcPresentationNotification")
    static let thpOIDCCancelNotification = Notification.Name("ThpOIDCCancelNotification")
}

public enum THPNotificationKey {
    case oidcUrl
}
