
#import <AppMetricaPush/AppMetricaPush.h>
#import "AMPFTokenSender.h"

@implementation AMPFTokenSender

+ (void)sendToken:(NSData *)token
{
#ifdef DEBUG
    AMPAppMetricaPushEnvironment pushEnvironment = AMPAppMetricaPushEnvironmentDevelopment;
#else
    AMPAppMetricaPushEnvironment pushEnvironment = AMPAppMetricaPushEnvironmentProduction;
#endif
    [AMPAppMetricaPush setDeviceTokenFromData:token pushEnvironment:pushEnvironment];
}

@end
