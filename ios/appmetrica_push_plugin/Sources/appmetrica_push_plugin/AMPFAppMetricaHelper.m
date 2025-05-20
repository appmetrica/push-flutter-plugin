
#if SWIFT_PACKAGE
    #import <appmetrica_plugin/../../AMAFAppMetricaActivator.h>
    #import <appmetrica_plugin/../../AMAFAppMetricaConfigConverterImplementation.h>
#else
    #import <appmetrica_plugin/AMAFAppMetricaActivator.h>
    #import <appmetrica_plugin/AMAFAppMetricaConfigConverterImplementation.h>
#endif
#import "AMPFAppMetricaHelper.h"

@implementation AMPFAppMetricaHelper

NSString *const kAMPFUserDefaultsConfigurationKey = @"io.appmetrica.analytics.push.flutter.Configuration";

+ (void)saveConfig:(NSString *)config
{
    [[NSUserDefaults standardUserDefaults] setObject:config forKey:kAMPFUserDefaultsConfigurationKey];
}

+ (BOOL)ensureActivated
{
    AMAFAppMetricaActivator *appMetricaActivator = [AMAFAppMetricaActivator sharedInstance];
    if ([appMetricaActivator isAlreadyActivated]) {
        return YES;
    }

    NSString *configStr = [AMPFAppMetricaHelper loadConfig];
    AMAAppMetricaConfiguration *config = [AMAFAppMetricaConfigConverterImplementation appMetricaConfigFromJson:configStr];
    if (config != nil) {
        [appMetricaActivator activateWithConfig:config];
        return YES;
    }
    return NO;
}

+ (NSString *)loadConfig
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kAMPFUserDefaultsConfigurationKey];
}

@end
