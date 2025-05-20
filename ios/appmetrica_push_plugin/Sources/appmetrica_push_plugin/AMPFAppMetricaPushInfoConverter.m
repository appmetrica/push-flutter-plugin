
#import "AMPFAppMetricaPushInfoConverter.h"
#import <AppMetricaPush/AppMetricaPush.h>

@implementation AMPFAppMetricaPushInfoConverter

+ (AMPFAppMetricaPushInfoPigeon *)toPigeon:(NSDictionary *)userInfo;
{
    AMPFAppMetricaPushInfoPigeon *pigeon = [[AMPFAppMetricaPushInfoPigeon alloc] init];
    
    pigeon.payload = [AMPAppMetricaPush userDataForNotification:userInfo];

    return pigeon;
}

@end
