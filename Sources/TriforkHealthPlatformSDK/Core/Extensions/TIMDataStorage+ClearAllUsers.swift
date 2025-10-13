import Foundation
import TIM

extension TIMDataStorage {
    public func clearAllUsers(exceptUserId: String? = nil) {
        availableUserIds
            .filter { $0 != exceptUserId }
            .forEach(self.clear)
    }
}
