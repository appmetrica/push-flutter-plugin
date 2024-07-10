
#import "AMPFAppMetricaPushPlugin.h"
#import <AppMetricaPush/AppMetricaPush.h>
#import "AMPFPigeon.h"
#import "AMPFAppMetricaPushImplementation.h"
#import "AMPFAppMetricaHelper.h"
#import "AMPFTokenStorage.h"
#import "AMPFTokenSender.h"
#import "AMPFUtils.h"

@interface AMPFAppMetricaPushPlugin ()

@property(nonatomic, readonly) NSObject<FlutterPluginRegistrar> *registrar;
@property(nonatomic, strong, readonly) AMPFTokenUpdateApi *tokenUpdateApi;

@end

@implementation AMPFAppMetricaPushPlugin

- (instancetype)initWithFlutterPluginRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    self = [super init];
    if (self) {
        _registrar = registrar;
        _tokenUpdateApi = [[AMPFTokenUpdateApi alloc] initWithBinaryMessenger:registrar.messenger];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_application_onDidFinishLaunchingNotification:)
                                                     name:UIApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    AMPFAppMetricaPushPigeonSetup(registrar.messenger, [[AMPFAppMetricaPushImplementation alloc] init]);
    [registrar publish:[[AMPFAppMetricaPushPlugin alloc] initWithFlutterPluginRegistrar:registrar]];
}

- (void)_application_onDidFinishLaunchingNotification:(NSNotification *)notification
{
    [self.registrar addApplicationDelegate:self];

    // Enable in-app push notifications handling in iOS 10
    if (@available(iOS 10.0, *)) {
        id<AMPUserNotificationCenterDelegate> delegate = [AMPAppMetricaPush userNotificationCenterDelegate];
        delegate.nextDelegate = [UNUserNotificationCenter currentNotificationCenter].delegate;
        [UNUserNotificationCenter currentNotificationCenter].delegate = delegate;
    }

    // need to call early. From dart will not work.
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    if ([AMPFAppMetricaHelper ensureActivated]) {
        [AMPAppMetricaPush handleApplicationDidFinishLaunchingWithOptions:notification.userInfo];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if ([AMPFAppMetricaHelper ensureActivated]) {
        [AMPFTokenSender sendToken:deviceToken];
    }
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
        if ([AMPFAppMetricaHelper ensureActivated]) {
            [AMPAppMetricaPush handleRemoteNotification:userInfo];
        }
        completionHandler(UIBackgroundFetchResultNewData);
        return YES;
    }
    return NO;
}

@end
