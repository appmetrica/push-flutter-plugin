
#import <UserNotifications/UserNotifications.h>
#import "AMPFAppMetricaPushImplementation.h"
#import "AMPFAppMetricaHelper.h"
#import "AMPFTokenStorage.h"
#import "AMPFTokenSender.h"
#import "AMPFPermissionOptionsConverter.h"
#import "AMPFUtils.h"

@implementation AMPFAppMetricaPushImplementation

- (void)activateWithError:(FlutterError **)error
{
    [AMPFTokenSender sendToken:[AMPFTokenStorage getToken]];
}

- (void)requestPermissionOptions:(AMPFPermissionOptions *)options error:(FlutterError **)error
{
    if (@available(iOS 10.0, *)) {
        UNAuthorizationOptions authorizationOptions = [AMPFPermissionOptionsConverter toUNAuthorizationOptions:options];
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:authorizationOptions completionHandler:^(BOOL granted, NSError *_Nullable error) {
        }];
    } else {
        // iOS 9
        UIUserNotificationType userNotificationTypes = [AMPFPermissionOptionsConverter toUIUserNotificationType:options];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

- (void)saveAppMetricaConfigConfig:(NSString *)config error:(FlutterError **)error
{
    [AMPFAppMetricaHelper saveConfig:config];
}

- (void)getTokensWithCompletion:(void (^)(NSDictionary<NSString *, NSString *> *, FlutterError *))completion
{
    NSString *token = [AMPFUtils stringForTokenData:[AMPFTokenStorage getToken]];
    if (token == nil) {
        completion(@{}, nil);
    } else {
        completion(@{@"apns": token}, nil);
    }
}

@end
