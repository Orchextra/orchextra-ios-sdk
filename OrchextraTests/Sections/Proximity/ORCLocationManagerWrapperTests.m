//
//  ORCLocationManagerWrapperTests.m
//  Orchextra
//
//  Created by Judith Medina on 11/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>

#import "ORCLocationManagerWrapper.h"
#import "CLLocationManagerMock.h"
#import "ORCUserLocationPersisterMock.h"

@interface ORCLocationManagerWrapperTests : XCTestCase
<CLLocationManagerDelegate>

@property (strong, nonatomic) ORCLocationManagerWrapper *locationWrapper;
@property (strong, nonatomic) ORCUserLocationPersisterMock *userLocationPersisterMock;
@property (strong, nonatomic) CLLocationManagerMock *locationManagerMock;

@end

@implementation ORCLocationManagerWrapperTests

- (void)setUp
{
    [super setUp];
    self.locationManagerMock = [[CLLocationManagerMock alloc] init];
    self.locationManagerMock.delegate = self;
    
    self.userLocationPersisterMock = [[ORCUserLocationPersisterMock alloc] init];
    self.locationWrapper = [[ORCLocationManagerWrapper alloc]
                            initWithCoreLocationManager:self.locationManagerMock
                            userLocationPersister:self.userLocationPersisterMock];
}

- (void)tearDown
{
    [super tearDown];
    self.locationManagerMock = nil;
    self.userLocationPersisterMock = nil;
    self.locationWrapper = nil;
}

@end
