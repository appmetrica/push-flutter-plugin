
#import "AMPFTokenStorage.h"

@implementation AMPFTokenStorage

NSString *const kAMPFUserDefaultsTokenKey = @"com.yandex.mobile.metrica.push.flutter.PushToken";

+ (void)saveToken:(NSData *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kAMPFUserDefaultsTokenKey];
}

+ (NSData *)getToken
{
    return [[NSUserDefaults standardUserDefaults] dataForKey:kAMPFUserDefaultsTokenKey];
}

@end
