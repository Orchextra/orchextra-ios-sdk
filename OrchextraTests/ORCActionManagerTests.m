//
//  ORCURLCommunicatorTests.m
//  Orchestra
//
//  Created by Judith Medina on 1/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <OCMockitoIOS/OCMockitoIOS.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "ORCProximityManager.h"
#import "ORCPushManager.h"
#import "ORCActionManager.h"
#import "ORCActionInterface.h"
#import "ORCAppConfigResponse.h"
#import "ORCConstants.h"

#import "ORCAction.h"
#import "ORCActionScanner.h"

@interface ORCActionManagerTests : XCTestCase

@property (strong, nonatomic) ORCActionManager *actionManager;
@property (strong, nonatomic) ORCProximityManager *proximityManagerMock;
@property (strong, nonatomic) ORCPushManager *notificationManagerMock;
@property (weak, nonatomic) id<ORCActionInterface> actionInterface;

@end

@implementation ORCActionManagerTests

- (void)setUp
{
    [super setUp];
    
    self.proximityManagerMock = MKTMock([ORCProximityManager class]);
    self.notificationManagerMock  = MKTMock([ORCPushManager class]);
    self.actionInterface = MKTMockProtocol(@protocol(ORCActionInterface));
    self.actionManager = [[ORCActionManager alloc] initWithProximity:self.proximityManagerMock
                                                 notificationManager:self.notificationManagerMock];
}

- (void)tearDown
{
    [super tearDown];
    
    self.actionInterface = nil;
}

- (void)test_start_geomarketing_with_regions
{

    // Prepare
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"POST_configuration" ofType:@"json"];
    NSData *dataResponse = [NSData dataWithContentsOfFile:path];
    ORCAppConfigResponse *response = [[ORCAppConfigResponse alloc] initWithData:dataResponse];
    
    [self.actionManager startGeoMarketingWithRegions:response.geoRegions];

    // Verify
    MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.proximityManagerMock) startProximityWithRegions:[captor capture]];
    
    NSArray *regions = [captor value];
    XCTAssertTrue([regions isEqualToArray:response.geoRegions]);
    
}

- (void)test_start_geomarketing_without_regions
{
    // Prepare
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"POST_confi_without_geomarketing" ofType:@"json"];
    NSData *dataResponse = [NSData dataWithContentsOfFile:path];
    ORCAppConfigResponse *response = [[ORCAppConfigResponse alloc] initWithData:dataResponse];
    
    [self.actionManager startGeoMarketingWithRegions:response.geoRegions];
    
    // Verify
    [MKTVerify(self.proximityManagerMock) stopProximity];
    [MKTVerifyCount(self.proximityManagerMock, MKTNever()) startProximityWithRegions:response.geoRegions];
    
}

- (void)test_trigger_location_event
{
    // Prepare
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(37.331705,
                                                                           -122.030237);
    NSString *originalIdentifier = @"Cupertino";
    CLLocationDistance radius = 500;
    
    CLCircularRegion *originalRegion = [[CLCircularRegion alloc]initWithCenter:locationCoordinate
                                                                radius:radius
                                                            identifier:originalIdentifier];
    
    // Execute
    [self.actionManager handleLocationEvent:originalRegion event:ORCTypeEventEnter];
    
    
    //Verify
    MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.proximityManagerMock) loadActionWithLocationEvent:[captor capture]
                                                                event:ORCTypeEventEnter];
    
    CLRegion *region = [captor value];
    XCTAssertTrue([region isEqual:originalRegion]);
    
}

- (void)test_got_scanner_action_from_fire_trigger
{
    // Prepare
    ORCAction *barcodeAction = [[ORCActionScanner alloc] init];
    barcodeAction.type = ORCTypeBarcode;
    barcodeAction.urlString = ORCSchemeScanner;
    barcodeAction.messageNotification = @"Message Notification";
    barcodeAction.titleNotification = @"Title Notification";
    
//    // Execute
//    [self.actionInterface didFireTriggerWithAction:barcodeAction
//                                fromViewController:nil];
//    
//    MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
//    [MKTVerify(self.notificationManagerMock) sendLocalPushNotificationWithValues:[captor capture]];
//    
//    NSDictionary *values = [captor value];
//    XCTAssertTrue([values[@"title"] isEqualToString:@"Title Notification"]);
//    XCTAssertTrue([values[@"body"] isEqualToString:@"Message Notification"]);
}


@end
