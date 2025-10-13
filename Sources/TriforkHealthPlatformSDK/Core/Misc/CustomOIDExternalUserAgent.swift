import AppAuth
import WebKit

public class THPOIDExternalUserAgent: OIDExternalUserAgentIOS {
    public override func present(_ request: OIDExternalUserAgentRequest, session: OIDExternalUserAgentSession) -> Bool {
        guard let url = request.externalUserAgentRequestURL() else {
            return false
        }
        NotificationCenter.default.post(
            name: .thpOIDCPresentationNotification,
            object: nil,
            userInfo: [THPNotificationKey.oidcUrl: url]
        )
        return true
    }
}
