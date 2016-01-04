//
//  ORCConfigurationInteractorTests.m
//  Orchextra
//
//  Created by Judith Medina on 2/12/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMockitoIOS/OCMockitoIOS.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "ORCConfigurationInteractor.h"
#import "ORCStorage.h"
#import "ORCAppConfigCommunicator.h"
#import "ORCAppConfigResponse.h"
#import "NSBundle+ORCBundle.h"
#import "ORCUser.h"

@interface ORCConfigurationInteractorTests : XCTestCase

@property (strong, nonatomic) ORCStorage *storageMock;
@property (strong, nonatomic) ORCAppConfigCommunicator *communicatorMock;
@property (strong, nonatomic) ORCConfigurationInteractor *configurationInteractor;
@property (strong, nonatomic) NSBundle *testBundle;

@end

@implementation ORCConfigurationInteractorTests

- (void)setUp
{
    [super setUp];
    
    self.storageMock = MKTMock([ORCStorage class]);
    self.communicatorMock = MKTMock([ORCAppConfigCommunicator class]);
    self.configurationInteractor = [[ORCConfigurationInteractor alloc] initWithStorage:self.storageMock communicator:self.communicatorMock];
    self.testBundle = [NSBundle bundleForClass:self.class];

}

- (void)tearDown
{
    [super tearDown];
    self.storageMock = nil;
    self.communicatorMock = nil;
    self.configurationInteractor = nil;
    self.testBundle = nil;
}

- (void)test_load_apiKey_apiSecret_success
{
    NSString *apiKey = @"key";
    NSString *apiSecret = @"secret";
    
    NSString *path = [self.testBundle pathForResource:@"POST_configuration" ofType:@"json"];
    NSData *dataResponse = [NSData dataWithContentsOfFile:path];
    
    __block BOOL completionBlockCalled = NO;
    __block NSError *errorTest = nil;
    
    [self.configurationInteractor loadProjectWithApiKey:apiKey apiSecret:apiSecret completion:^(NSArray *regions, NSError *error) {
        completionBlockCalled = YES;
        errorTest = error;
        XCTAssertTrue(regions.count == 3);
    }];
    
    MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadConfigurationWithCompletion:[captor capture]];
    
    CompletionOrchestraConfigResponse completion = [captor value];
    ORCAppConfigResponse *response = [[ORCAppConfigResponse alloc] initWithData:dataResponse];
    completion(response);
    
    XCTAssertTrue(completionBlockCalled);
    XCTAssertNil(errorTest);
}


@end
