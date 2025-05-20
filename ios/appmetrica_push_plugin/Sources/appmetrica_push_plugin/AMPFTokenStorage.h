
#import <Foundation/Foundation.h>

@interface AMPFTokenStorage : NSObject

+ (void)saveToken:(NSData *)token;
+ (NSData *)getToken;

@end
