
#import "AMPFUtils.h"

@implementation AMPFUtils

+ (NSString *)stringForTokenData:(NSData *)deviceToken
{
    if (deviceToken.length == 0) {
        return nil;
    }

    const char *bytes = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    for (NSUInteger i = 0; i < deviceToken.length; ++i) {
        [token appendFormat:@"%02.2hhx", bytes[i]];
    }
    return [token copy];
}

@end
