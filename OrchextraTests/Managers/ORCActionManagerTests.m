//
//  ORCURLCommunicatorTests.m
//  Orchextra
//
//  Created by Judith Medina on 1/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <OCMockitoIOS/OCMockitoIOS.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "ORCProximityManager.h"
#import "ORCActionManager.h"
#import "ORCActionInterface.h"
#import "ORCAppConfigResponse.h"
#import "ORCConstants.h"
#import "ORCPushManagerMock.h"
#import "ORCStatisticsInteractorMock.h"

#import "ORCAction.h"
#import "ORCActionScanner.h"
#import "ORCWireframe.h"

@interface ORCActionManagerTests : XCTestCase

@property (weak, nonatomic) id<ORCActionInterface> actionInterface;
@property (strong, nonatomic) ORCActionManager *actionManager;
@property (strong, nonatomic) ORCProximityManager *proximityManagerMock;
@property (strong, nonatomic) ORCPushManagerMock *pushManagerMock;
@property (strong, nonatomic) ORCStatisticsInteractorMock *statisticsInteractorMock;
@property (strong, nonatomic) ORCWireframe *wireframeMock;
@property (strong, nonatomic) ORCAction *action;

@end

@implementation ORCActionManagerTests

- (void)setUp
{
    [super setUp];
    
    self.action = [[ORCAction alloc] init];
    self.action.type = ORCTypeBarcode;
    self.action.urlString = ORCSchemeScanner;
    
    self.pushManagerMock  = [[ORCPushManagerMock alloc] init];
    self.statisticsInteractorMock = [[ORCStatisticsInteractorMock alloc] init];
    self.proximityManagerMock = MKTMock([ORCProximityManager class]);
    self.actionInterface = MKTMockProtocol(@protocol(ORCActionInterface));
    
    self.actionManager = [[ORCActionManager alloc] initWithProximity:self.proximityManagerMock
                                                 notificationManager:self.pushManagerMock
                                                statisticsInteractor:self.statisticsInteractorMock
                                                           wireframe:self.wireframeMock];
    
}

- (void)tearDown
{
    [super tearDown];
    
    self.actionInterface = nil;
    self.proximityManagerMock = nil;
    self.pushManagerMock = nil;
    self.statisticsInteractorMock = nil;
    self.actionManager = nil;
}

-(void)test_prepareActionTobeExecute_without_notification
{
    //Prepare
    self.action.bodyNotification = nil;
    self.action.titleNotification = nil;
    
    [self.actionManager prepareActionToBeExecute:self.action];
    
    XCTAssertTrue(self.statisticsInteractorMock.outTrackActionHasBeenLaunchedCalled);
    XCTAssertFalse(self.pushManagerMock.outSendLocalPushNotificationCalled);
    XCTAssertFalse(self.pushManagerMock.outShowAlertViewWithTitleCalled);
}

- (void)test_prepareActionTobeExecute_where_scheduleTime_zero
{
    //Prepare
    self.action.bodyNotification = @"Message";
    self.action.titleNotification = @"Title";
    self.action.scheduleTime = 0;
    
    //Execute
    [self.actionManager prepareActionToBeExecute:self.action];
    
    //Verify
    XCTAssertTrue(self.pushManagerMock.outShowAlertViewWithTitleCalled);
    XCTAssertFalse(self.pushManagerMock.outSendLocalPushNotificationCalled);
}

- (void)test_prepareActionTobeExecute_where_scheduleTime_more_than_zero
{
    //Prepare
    self.action.bodyNotification = @"Message";
    self.action.titleNotification = @"Title";
    self.action.scheduleTime = 10;
    
    //Execute
    [self.actionManager prepareActionToBeExecute:self.action];
    
    //Verify
    XCTAssertFalse(self.pushManagerMock.outShowAlertViewWithTitleCalled);
    XCTAssertTrue(self.pushManagerMock.outSendLocalPushNotificationCalled);
}

- (void)test_didFireTrigger_action_withNotification_withoutViewController
{
    //Prepare
    self.action.bodyNotification = @"Message";
    self.action.titleNotification = @"Title";
    self.action.scheduleTime = 0;
    
    //Execute
    [self.actionManager didFireTriggerWithAction:self.action];
    
    XCTAssertTrue(self.pushManagerMock.outShowAlertViewWithTitleCalled);
}

- (void)test_didFireTrigger_action_withoutNotification_withoutViewController
{
    //Prepare
    self.action.bodyNotification = nil;
    self.action.titleNotification = nil;
    self.action.scheduleTime = 0;
    
    //Execute
    [self.actionManager didFireTriggerWithAction:self.action];
    
    XCTAssertFalse(self.pushManagerMock.outShowAlertViewWithTitleCalled);
    XCTAssertTrue(self.statisticsInteractorMock.outTrackActionHasBeenLaunchedCalled);
}
@end
