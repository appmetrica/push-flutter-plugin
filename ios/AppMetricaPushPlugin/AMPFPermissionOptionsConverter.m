
#import "AMPFPermissionOptionsConverter.h"

@implementation AMPFPermissionOptionsConverter

+ (UNAuthorizationOptions)toUNAuthorizationOptions:(AMPFPermissionOptions *)options
{
    UNAuthorizationOptions nativeOptions = UNAuthorizationOptionNone;

    if (options.alert.boolValue) {
        nativeOptions |= UNAuthorizationOptionAlert;
    }

    if (options.badge.boolValue) {
        nativeOptions |= UNAuthorizationOptionBadge;
    }

    if (options.sound.boolValue) {
        nativeOptions |= UNAuthorizationOptionSound;
    }

    return nativeOptions;
}

+ (UIUserNotificationType)toUIUserNotificationType:(AMPFPermissionOptions *)options
{
    UIUserNotificationType nativeOptions = UIUserNotificationTypeNone;

    if (options.alert.boolValue) {
        nativeOptions |= UIUserNotificationTypeAlert;
    }

    if (options.badge.boolValue) {
        nativeOptions |= UIUserNotificationTypeBadge;
    }

    if (options.sound.boolValue) {
        nativeOptions |= UIUserNotificationTypeSound;
    }

    return nativeOptions;
}

@end
