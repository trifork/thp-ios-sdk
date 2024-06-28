//
//  Notification.Name+Extension.swift
//  
//
//  Created by Nicolai Harbo on 28/08/2023.
//

import Foundation

public extension Notification.Name {
    static let thpOIDCPresentationNotification = Notification.Name("ThpOidcPresentationNotification")
    static let thpOIDCLoadingTokenNotification = Notification.Name("ThpOIDCLoadingTokenNotification")
}

public enum THPNotificationKey {
    case oidcUrl
}
