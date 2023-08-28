//
//  Notification.Name+Extension.swift
//  
//
//  Created by Nicolai Harbo on 28/08/2023.
//

import Foundation

public extension Notification.Name {
    static let thpOidcPresentationNotification = Notification.Name("ThpOidcPresentationNotification")
}

public enum THPNotificationKey {
    case oidcUrl
}
