//
//  OrchextraTests.m
//  Orchestra
//
//  Created by Judith Medina on 1/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <OCMockitoIOS/OCMockitoIOS.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "Orchextra.h"
#import "OrchextraTests-Swift.h"

#import "ORCActionManager.h"
#import "ORCSettingsInteractor.h"
#import "ORCAction.h"
#import "ORCConstants.h"
#import "ORCAppConfigResponse.h"
#import "ORCApplicationCenter.h"

@interface OrchextraTests : XCTestCase

@property (strong, nonatomic) Orchextra *orchextra;
@property (strong, nonatomic) ORCActionManager *actionManagerMock;
@property (strong, nonatomic) ORCSettingsInteractor *interactorMock;
@property (strong, nonatomic) ORCApplicationCenter *applicationCenterMock;
@property (strong, nonatomic) ORCUser *userMock;
@property (strong, nonatomic) NSBundle *testBundle;

@end

@implementation OrchextraTests

- (void)setUp
{
    [super setUp];
    
    self.actionManagerMock = MKTMock([ORCActionManager class]);
    self.interactorMock = MKTMock([ORCSettingsInteractor class]);
    self.applicationCenterMock = MKTMock([ORCApplicationCenter class]);
    
    self.orchextra = [[Orchextra alloc] initWithActionManager:self.actionManagerMock
                                             configInteractor:self.interactorMock
                                            applicationCenter:self.applicationCenterMock];
    

    self.testBundle = [NSBundle bundleForClass:self.class];
}

- (void)tearDown
{
    [super tearDown];
    
    self.actionManagerMock = nil;
    self.interactorMock = nil;
    self.testBundle = nil;
}

- (void)test_set_api_key_secret_success
{
    NSString *apiKey = @"key";
    NSString *apiSecret = @"secret";

    NSString *path = [self.testBundle pathForResource:@"POST_configuration" ofType:@"json"];
    NSData *dataResponse = [NSData dataWithContentsOfFile:path];
    
    __block BOOL successTest = NO;
    __block BOOL completionBlockCalled = NO;
    __block NSError *errorTest = nil;
    
    [self.orchextra setApiKey:apiKey apiSecret:apiSecret completion:^(BOOL success, NSError *error) {
        completionBlockCalled = YES;
        successTest = success;
        errorTest = error;
    }];
    
    MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.interactorMock) loadProjectWithApiKey:apiKey apiSecret:apiSecret completion:[captor capture]];
    
    CompletionProjectSettings completion = [captor value];
    ORCAppConfigResponse *response = [[ORCAppConfigResponse alloc] initWithData:dataResponse];
    completion(response.success, response.error);
    
    XCTAssertTrue(completionBlockCalled);
    XCTAssertTrue(successTest);
    XCTAssertNil(errorTest);
    
    [MKTVerify(self.actionManagerMock) startWithAppConfiguration];
}

- (void)test_set_api_key_secret_failure
{
    NSString *apiKey = @"key";
    NSString *apiSecret = @"secret";
    
    NSString *path = [self.testBundle pathForResource:@"POST_configuration_failure" ofType:@"json"];
    NSData *dataResponse = [NSData dataWithContentsOfFile:path];
    
    __block BOOL successTest = NO;
    __block BOOL completionBlockCalled = NO;
    __block NSError *errorTest = nil;
    
    [self.orchextra setApiKey:apiKey apiSecret:apiSecret completion:^(BOOL success, NSError *error) {
        completionBlockCalled = YES;
        successTest = success;
        errorTest = error;
    }];
    
    MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.interactorMock) loadProjectWithApiKey:apiKey apiSecret:apiSecret completion:[captor capture]];
    
    CompletionProjectSettings completion = [captor value];
    ORCAppConfigResponse *response = [[ORCAppConfigResponse alloc] initWithData:dataResponse];
    completion(response.success, response.error);
    
    XCTAssertTrue(completionBlockCalled);
    XCTAssertFalse(successTest);
    XCTAssertNotNil(errorTest);
    
    [MKTVerifyCount(self.actionManagerMock, MKTNever()) startWithAppConfiguration];
}

- (void)test_start_scanner
{
    [self.orchextra startScanner];
    
    MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.actionManagerMock) launchAction:[captor capture]];
    
    ORCAction *capturedAction = [captor value];
    
    XCTAssertTrue(capturedAction.type == ORCActionOpenScannerID);
    XCTAssertTrue([capturedAction.urlString isEqualToString:ORCSchemeScanner]);
}

- (void)test_configuration_response_with_geomarketing
{
    NSString *path = [self.testBundle pathForResource:@"POST_configuration" ofType:@"json"];
    XCTAssertNotNil(path);
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    XCTAssertNotNil(data);
    
    ORCAppConfigResponse *response = [[ORCAppConfigResponse alloc] initWithData:data];
    
    XCTAssertTrue(response.success);
    XCTAssertNil(response.error);
    XCTAssertTrue(response.geoRegions.count == 2, @"Number regions: %lu", (unsigned long)response.geoRegions.count);
    XCTAssertTrue(response.beaconRegions.count == 1, @"Number regions: %lu", (unsigned long)response.geoRegions.count);

}

- (void)test_configuration_response_without_geomarketing
{
    NSString *path = [self.testBundle pathForResource:@"POST_confi_without_geomarketing" ofType:@"json"];
    XCTAssertNotNil(path);
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    XCTAssertNotNil(data);
    
    ORCAppConfigResponse *response = [[ORCAppConfigResponse alloc] initWithData:data];
    
    XCTAssertTrue(response.success);
    XCTAssertNil(response.error);
    XCTAssertTrue(response.geoRegions.count == 0, @"Number regions: %lu", (unsigned long)response.geoRegions.count);
}

- (void)test_configuration_response_failure
{
    NSBundle *testBundle = [NSBundle bundleForClass:self.class];
    NSString *path = [testBundle pathForResource:@"POST_configuration_failure" ofType:@"json"];
    XCTAssertNotNil(path);
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    XCTAssertNotNil(data);
    
    ORCAppConfigResponse *response = [[ORCAppConfigResponse alloc] initWithData:data];
    XCTAssertFalse(response.success);
    XCTAssertNotNil(response.error);
    XCTAssertTrue(response.error.code == 403, @"Error code: %li", (long)response.error.code);
}

- (void)test_configuration_response_failure_html
{
    NSBundle *testBundle = [NSBundle bundleForClass:self.class];
    NSString *path = [testBundle pathForResource:@"POST_configuration_failure_html" ofType:@"html"];
    XCTAssertNotNil(path);
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    XCTAssertNotNil(data);
    
    ORCAppConfigResponse *response = [[ORCAppConfigResponse alloc] initWithData:data];
    XCTAssertFalse(response.success);
    XCTAssertNotNil(response.error);
    XCTAssertTrue(response.error.code == -1, @"Unexpected error.");
}

- (void)test_configuration_response_failure_empty_json
{
    NSBundle *testBundle = [NSBundle bundleForClass:self.class];
    NSString *path = [testBundle pathForResource:@"POST_configuration_failure_empty" ofType:@"json"];
    XCTAssertNotNil(path);
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    XCTAssertNotNil(data);
    
    ORCAppConfigResponse *response = [[ORCAppConfigResponse alloc] initWithData:data];
    XCTAssertFalse(response.success);
    XCTAssertNotNil(response.error);
    XCTAssertTrue(response.error.code == -1, @"Unexpected error.");
}

- (void)test_configuration_response_with_Customfields
{
    NSString *path = [self.testBundle pathForResource:@"POST_confi_with_customfieldsAndTags" ofType:@"json"];
    XCTAssertNotNil(path);
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    XCTAssertNotNil(data);
    
    ORCAppConfigResponse *response = [[ORCAppConfigResponse alloc] initWithData:data];
    
    XCTAssertTrue(response.success);
    XCTAssertNil(response.error);
    XCTAssertTrue(response.availableCustomFields.count == 3, @"Number of available custom fields: %lu", (unsigned long)response.availableCustomFields.count);
    XCTAssertTrue(response.userCustomFields.count == 2, @"Number of user custom fields: %lu", (unsigned long)response.userCustomFields.count);
}

- (void)test_configuration_response_with_user_tags
{
    NSString *path = [self.testBundle pathForResource:@"POST_confi_with_customfieldsAndTags" ofType:@"json"];
    XCTAssertNotNil(path);
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    XCTAssertNotNil(data);
    
    ORCAppConfigResponse *response = [[ORCAppConfigResponse alloc] initWithData:data];
    
    XCTAssertTrue(response.success);
    XCTAssertNil(response.error);
    XCTAssertTrue(response.userTags.count == 2, @"Number of user tags: %lu", (unsigned long)response.userTags.count);
}

- (void)test_configuration_response_with_device_tags
{
    NSString *path = [self.testBundle pathForResource:@"POST_confi_with_customfieldsAndTags" ofType:@"json"];
    XCTAssertNotNil(path);
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    XCTAssertNotNil(data);
    
    ORCAppConfigResponse *response = [[ORCAppConfigResponse alloc] initWithData:data];
    
    XCTAssertTrue(response.success);
    XCTAssertNil(response.error);
    XCTAssertTrue(response.deviceTags.count == 2, @"Number of device tags: %lu", (unsigned long)response.deviceTags.count);
}

- (void)test_configuration_response_with_eddystoneRegions
{
    NSString *path = [self.testBundle pathForResource:@"POST_configuration_with_eddystone_regions" ofType:@"json"];
    XCTAssertNotNil(path);
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    XCTAssertNotNil(data);
    
    ORCAppConfigResponse *response = [[ORCAppConfigResponse alloc] initWithData:data];
    
    ORCEddystoneUID *uid1 = [[ORCEddystoneUID alloc] initWithNamespace:@"a904bf9dd8e13190483c"instance:nil];
    
    ORCEddystoneRegion *region1 = [[ORCEddystoneRegion alloc] initWithUid:uid1
                                                                    code:@"595f79713570a181468b456e"
                                                           notifyOnEntry:YES
                                                            notifyOnExit: YES];
    
    ORCEddystoneUID *uid2 = [[ORCEddystoneUID alloc] initWithNamespace:@"636f6b65634063656575"instance:nil];
    
    ORCEddystoneRegion *region2 = [[ORCEddystoneRegion alloc] initWithUid:uid2
                                                                     code:@"59631d973570a131308b4570"
                                                            notifyOnEntry:YES
                                                             notifyOnExit: YES];
    
    ORCEddystoneUID *uid3 = [[ORCEddystoneUID alloc] initWithNamespace:@"11111111111111111111"instance:nil];
    
    ORCEddystoneRegion *region3 = [[ORCEddystoneRegion alloc] initWithUid:uid3
                                                                     code:@"596640c83570a145248b4592"
                                                            notifyOnEntry:YES
                                                             notifyOnExit: YES];

    
    ORCEddystoneRegion *regionRetrieved1 = [response.eddystoneRegions objectAtIndex:0];
    ORCEddystoneRegion *regionRetrieved2 = [response.eddystoneRegions objectAtIndex:1];
    ORCEddystoneRegion *regionRetrieved3 = [response.eddystoneRegions objectAtIndex:2];
    
    XCTAssertTrue(response.success);
    XCTAssertNil(response.error);
    XCTAssertTrue(response.eddystoneRegions.count == 3, @"Number of eddystone regions: %lu", (unsigned long)response.eddystoneRegions.count);
    
    XCTAssertTrue([regionRetrieved1 isEqual:region1]);
    XCTAssertTrue([regionRetrieved2 isEqual:region2]);
    XCTAssertTrue([regionRetrieved3 isEqual:region3]);
}

- (void)test_configuration_response_without_eddystoneRegions
{
    NSString *path = [self.testBundle pathForResource:@"POST_configuration_without_eddystone_regions" ofType:@"json"];
    XCTAssertNotNil(path);
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    XCTAssertNotNil(data);
    
    ORCAppConfigResponse *response = [[ORCAppConfigResponse alloc] initWithData:data];
    
    XCTAssertTrue(response.success);
    XCTAssertNil(response.error);
    XCTAssertTrue(response.eddystoneRegions.count == 0, @"Number of eddystone regions: %lu", (unsigned long)response.eddystoneRegions.count);
}
@end
