
#import <Foundation/Foundation.h>

@interface AMPFAppMetricaHelper : NSObject

+ (void)saveConfig:(NSString *)config;
+ (BOOL)ensureActivated;

@end
