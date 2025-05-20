
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

@end
