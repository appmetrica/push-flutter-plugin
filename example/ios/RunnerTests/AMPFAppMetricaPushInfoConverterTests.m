#import <XCTest/XCTest.h>

#import "AMPFAppMetricaPushInfoConverter.h"
#import "AMPFPigeon.h"

@interface AMPFAppMetricaPushInfoConverterTests : XCTestCase
@end

@implementation AMPFAppMetricaPushInfoConverterTests

- (void)testToPigeonWithEmptyUserInfo
{
    AMPFAppMetricaPushInfoPigeon *pigeon =
        [AMPFAppMetricaPushInfoConverter toPigeon:@{}];
    XCTAssertNotNil(pigeon);
    XCTAssertNil(pigeon.payload);
}

- (void)testToPigeonWithNilUserInfo
{
    AMPFAppMetricaPushInfoPigeon *pigeon =
        [AMPFAppMetricaPushInfoConverter toPigeon:nil];
    XCTAssertNotNil(pigeon);
    XCTAssertNil(pigeon.payload);
}

- (void)testToPigeonWithUserData
{
    NSDictionary *userInfo = @{
        @"aps" : @{ @"alert" : @"Message" },
        @"yamp" : @{
            @"i" : @"notification-id",
            @"d" : @"custom-user-payload",
        },
    };
    AMPFAppMetricaPushInfoPigeon *pigeon =
        [AMPFAppMetricaPushInfoConverter toPigeon:userInfo];
    XCTAssertNotNil(pigeon);
    XCTAssertEqualObjects(pigeon.payload, @"custom-user-payload");
}

@end
