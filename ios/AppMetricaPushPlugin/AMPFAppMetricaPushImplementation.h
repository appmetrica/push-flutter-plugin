
#import "AMPFPigeon.h"

@interface AMPFAppMetricaPushImplementation : NSObject<AMPFAppMetricaPushPigeon>

- (void)activateWithError:(FlutterError **)error;
- (void)requestPermissionOptions:(AMPFPermissionOptions *)options error:(FlutterError **)error;
- (void)saveAppMetricaConfigConfig:(NSString *)config error:(FlutterError **)error;
- (void)getTokensWithCompletion:(void (^)(NSDictionary<NSString *, NSString *> *, FlutterError *))completion;

@end
