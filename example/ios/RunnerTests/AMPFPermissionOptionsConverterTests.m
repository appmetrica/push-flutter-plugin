#import <XCTest/XCTest.h>
#import <UserNotifications/UserNotifications.h>

#import "AMPFPermissionOptionsConverter.h"
#import "AMPFPigeon.h"

@interface AMPFPermissionOptionsConverterTests : XCTestCase
@end

@implementation AMPFPermissionOptionsConverterTests

- (void)testConvertsAlertBadgeSoundCombinations
{
    AMPFPermissionOptions *none =
        [AMPFPermissionOptions makeWithAlert:@NO badge:@NO sound:@NO];
    XCTAssertEqual(
        [AMPFPermissionOptionsConverter toUNAuthorizationOptions:none],
        UNAuthorizationOptionNone
    );

    AMPFPermissionOptions *all =
        [AMPFPermissionOptions makeWithAlert:@YES badge:@YES sound:@YES];
    UNAuthorizationOptions converted =
        [AMPFPermissionOptionsConverter toUNAuthorizationOptions:all];
    XCTAssertTrue((converted & UNAuthorizationOptionAlert) != 0);
    XCTAssertTrue((converted & UNAuthorizationOptionBadge) != 0);
    XCTAssertTrue((converted & UNAuthorizationOptionSound) != 0);

    AMPFPermissionOptions *alertOnly =
        [AMPFPermissionOptions makeWithAlert:@YES badge:@NO sound:@NO];
    XCTAssertEqual(
        [AMPFPermissionOptionsConverter toUNAuthorizationOptions:alertOnly],
        UNAuthorizationOptionAlert
    );
}

@end
