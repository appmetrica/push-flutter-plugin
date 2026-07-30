
#import "../../AMPFAppMetricaPushImplementation.h"
#import "../../AMPFAppMetricaPushInfoConverter.h"
#import "../../AMPFPigeon.h"
#import "../../AMPFTokenSender.h"
#import "../../AMPFTokenStorage.h"
#import "../../AMPFUtils.h"
#import "AMPFAppMetricaPushPlugin.h"
#import <AppMetricaPush/AppMetricaPush.h>
#import <UserNotifications/UserNotifications.h>

@interface AMPFAppMetricaPushPlugin ()

@property(nonatomic, readonly) NSObject<FlutterPluginRegistrar> *registrar;
@property(nonatomic, strong, readonly) AMPFTokenUpdateApi *tokenUpdateApi;
@property(nonatomic, strong, readonly) AMPFPushReceiverApi *pushReceiverApi;
@property(nonatomic, strong, readonly) AMPFAppMetricaPushImplementation *appMetricaPush;
@property(nonatomic, weak, nullable) id<UNUserNotificationCenterDelegate> nextDelegate;
@end

@implementation AMPFAppMetricaPushPlugin

- (instancetype)initWithFlutterPluginRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    self = [super init];
    if (self) {
        _registrar = registrar;
        _tokenUpdateApi = [[AMPFTokenUpdateApi alloc] initWithBinaryMessenger:registrar.messenger];
        _pushReceiverApi = [[AMPFPushReceiverApi alloc] initWithBinaryMessenger:registrar.messenger];
        _appMetricaPush = [[AMPFAppMetricaPushImplementation alloc] init];

        AMPFAppMetricaPushPigeonSetup(registrar.messenger, self.appMetricaPush);
        [self.registrar addApplicationDelegate:self];
        [self.registrar addSceneDelegate:self];
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    [registrar publish:[[AMPFAppMetricaPushPlugin alloc] initWithFlutterPluginRegistrar:registrar]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Enable in-app push notifications handling in iOS 10
    UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    if (![notificationCenter.delegate conformsToProtocol:@protocol(FlutterAppLifeCycleProvider)]) {
        id<AMPUserNotificationCenterDelegate> appMetricaPushDelegate = [AMPAppMetricaPush userNotificationCenterDelegate];
        _nextDelegate = appMetricaPushDelegate;
        
        if (notificationCenter.delegate != self) {
            appMetricaPushDelegate.nextDelegate = notificationCenter.delegate;
            notificationCenter.delegate = self;
        }
    }
    
    // need to call early. From dart will not work.
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];

    if ([AMPAppMetricaPush isNotificationRelatedToSDK:userInfo]) {
        [AMPAppMetricaPush handleApplicationDidFinishLaunchingWithOptions:userInfo];
        [self.appMetricaPush setUserInfo:userInfo];
        [self.pushReceiverApi onPushReceivedPushInfoPigeon:[AMPFAppMetricaPushInfoConverter toPigeon:userInfo]
                                                completion:^(FlutterError *_Nullable error) {
            if (error != nil) {
                NSLog(@"%@", error.description);
            }
        }];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [AMPFTokenSender sendToken:deviceToken];
    [AMPFTokenStorage saveToken:deviceToken];

    NSString *strToken = [AMPFUtils stringForTokenData:deviceToken];
    NSDictionary *tokens = strToken == nil ? @{} : @{@"apns": strToken};
    [self.tokenUpdateApi onTokenUpdatedNewTokens:tokens completion:^(FlutterError *_Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.description);
        }
    }];
}

- (BOOL)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
      fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if ([AMPAppMetricaPush isNotificationRelatedToSDK:userInfo]) {
        [AMPAppMetricaPush handleRemoteNotification:userInfo];
        [self.pushReceiverApi onPushReceivedPushInfoPigeon:[AMPFAppMetricaPushInfoConverter toPigeon:userInfo]
                                                completion:^(FlutterError *_Nullable error) {
            if (error != nil) {
                NSLog(@"%@", error.description);
            }
        }];
        completionHandler(UIBackgroundFetchResultNewData);
        return YES;
    }
    return NO;
}

- (BOOL)scene:(UIScene *)scene
    willConnectToSession:(UISceneSession *)session
                 options:(UISceneConnectionOptions *)connectionOptions
{
    UNNotificationResponse *notificationResponse = connectionOptions.notificationResponse;
    if (notificationResponse != nil) {
        NSDictionary *userInfo = notificationResponse.notification.request.content.userInfo;
        if ([AMPAppMetricaPush isNotificationRelatedToSDK:userInfo]) {
            [AMPAppMetricaPush handleApplicationDidFinishLaunchingWithOptions:userInfo];
            [self.appMetricaPush setUserInfo:userInfo];
            [self.pushReceiverApi onPushReceivedPushInfoPigeon:[AMPFAppMetricaPushInfoConverter toPigeon:userInfo]
                                                    completion:^(FlutterError *_Nullable error) {
                if (error != nil) {
                    NSLog(@"%@", error.description);
                }
            }];
        }
    }
    // Always NO: we only observe the launch notification and must not consume
    // connectionOptions so other plugins (e.g. firebase_messaging) still receive them.
    return NO;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;

    if ([AMPAppMetricaPush isNotificationRelatedToSDK:userInfo]) {
        [AMPAppMetricaPush handleRemoteNotification:userInfo];
        [self.pushReceiverApi onPushReceivedPushInfoPigeon:[AMPFAppMetricaPushInfoConverter toPigeon:userInfo]
                                                completion:^(FlutterError *_Nullable error) {
            if (error != nil) {
                NSLog(@"%@", error.description);
            }
        }];
    }
    if (self.nextDelegate != nil) {
        [self.nextDelegate userNotificationCenter:center
                   didReceiveNotificationResponse:response
                            withCompletionHandler:completionHandler];
    }
    else {
        completionHandler();
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    if (self.nextDelegate != nil) {
        [self.nextDelegate userNotificationCenter:center
                          willPresentNotification:notification
                            withCompletionHandler:completionHandler];
    }
    else {
        completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
   openSettingsForNotification:(nullable UNNotification *)notification
{
    if (self.nextDelegate != nil) {
        [self.nextDelegate userNotificationCenter:center
                      openSettingsForNotification:notification];
    }
}

@end
