
#import <UserNotifications/UserNotifications.h>
#import "AMPFAppMetricaPushImplementation.h"
#import "AMPFTokenStorage.h"
#import "AMPFTokenSender.h"
#import "AMPFPermissionOptionsConverter.h"
#import "AMPFUtils.h"
#import "AMPFPigeon.h"
#import "AMPFAppMetricaPushInfoConverter.h"

@interface AMPFAppMetricaPushImplementation()
@property(nonatomic, copy) NSDictionary *userInfo;
@end

@implementation AMPFAppMetricaPushImplementation

- (void)activateWithError:(FlutterError **)error
{
    [AMPFTokenSender sendToken:[AMPFTokenStorage getToken]];
}

- (void)activateWithProvidersProviders:(NSArray<NSString *> *)providers
                                 error:(FlutterError **)error {
    [self activateWithError:error];
}

- (void)requestPermissionOptions:(AMPFPermissionOptions *)options error:(FlutterError **)error
{
    UNAuthorizationOptions authorizationOptions = [AMPFPermissionOptionsConverter toUNAuthorizationOptions:options];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:authorizationOptions completionHandler:^(BOOL granted, NSError *_Nullable error) {
    }];
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

- (void)getLaunchPushInfoWithCompletion:(void (^)(AMPFAppMetricaPushInfoPigeon *, FlutterError *))completion {
    if (self.userInfo != nil) {
        completion([AMPFAppMetricaPushInfoConverter toPigeon:self.userInfo], nil);
    } else {
        completion([[AMPFAppMetricaPushInfoPigeon alloc] init], nil);
    }
}

- (void)enableLoggerWithError:(FlutterError **)error {
    // do nothing
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    _userInfo = userInfo;
}

@end
