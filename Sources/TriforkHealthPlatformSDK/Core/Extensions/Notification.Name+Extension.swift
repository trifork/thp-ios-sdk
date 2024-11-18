//
//  Notification.Name+Extension.swift
//  
//
//  Created by Nicolai Harbo on 28/08/2023.
//

import Foundation

public extension Notification.Name {
    static let thpOIDCPresentationNotification = Notification.Name("ThpOidcPresentationNotification")
    static let thpOIDCCancelNotification = Notification.Name("ThpOIDCCancelNotification")
}

public enum THPNotificationKey {
    case oidcUrl
}
