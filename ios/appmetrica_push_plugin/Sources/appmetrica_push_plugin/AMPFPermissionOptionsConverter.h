
#import <UserNotifications/UserNotifications.h>
#import "AMPFPigeon.h"

@interface AMPFPermissionOptionsConverter : NSObject

+ (UNAuthorizationOptions)toUNAuthorizationOptions:(AMPFPermissionOptions *)options;

@end
