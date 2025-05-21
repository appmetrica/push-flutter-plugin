
import UserNotifications
import AppMetricaPush

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    private let syncQueue = DispatchQueue(label: "NotificationService.syncQueue")

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if bestAttemptContent != nil {
            // Need for 'receive' tracking
            AppMetricaPush.setExtensionAppGroup("group.com.yandex.appmetricapushplugin.appmetricaPushPluginExample")
            AppMetricaPush.handleDidReceive(request)
            // Need to add image to push
            AppMetricaPush.downloadAttachments(for: request) { attachments, error in
                if let error = error {
                    print("Error: \(error)")
                }
                self.completeWithBestAttempt(attachments: attachments)
            }
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        completeWithBestAttempt(attachments: nil)
    }

    private func completeWithBestAttempt(attachments: [UNNotificationAttachment]?) {
        syncQueue.sync {
            if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
                if let attachments = attachments {
                    bestAttemptContent.attachments = attachments
                }
                contentHandler(bestAttemptContent)
                self.bestAttemptContent = nil
                self.contentHandler = nil
            }
        }
    }
}
