//
//  CustomOIDExternalUserAgent.swift
//  
//
//  Created by Nicolai Harbo on 28/08/2023.
//

import AppAuth
import WebKit

class THPOIDExternalUserAgent: OIDExternalUserAgentIOS {
    public override func present(_ request: OIDExternalUserAgentRequest, session: OIDExternalUserAgentSession) -> Bool {
        guard let url = request.externalUserAgentRequestURL() else {
            return false
        }
        NotificationCenter.default.post(
            name: .thpOidcPresentationNotification,
            object: nil,
            userInfo: [THPNotificationKey.oidcUrl: url]
        )
        return true
    }
}
