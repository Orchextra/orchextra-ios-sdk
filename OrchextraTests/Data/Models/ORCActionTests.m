//
//  ORCActionTests.m
//  Orchextra
//
//  Created by Judith Medina on 12/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ORCAction.h"
#import "ORCActionScanner.h"
#import "ORCActionBrowser.h"
#import "ORCActionWebView.h"
#import "ORCActionVuforia.h"
#import "ORCActionInterface.h"

@interface ORCActionTests : XCTestCase

@property (strong, nonatomic) NSBundle *testBundle;
@property (weak, nonatomic) id<ORCActionInterface> actionInterfaceMock;

@end

@implementation ORCActionTests

- (void)setUp
{
    [super setUp];
    
    self.testBundle = [NSBundle bundleForClass:self.class];

}

- (void)tearDown
{
    [super tearDown];
    self.testBundle = nil;
}

- (void)test_init_action_with_json
{
    NSDictionary *json = [self jsonFromFileName:@"GET_action_without_schedule"];
    
    ORCAction *action = [[ORCAction alloc] initWithJSON:json];
    XCTAssertNotNil(action);
    
    XCTAssertTrue([action isKindOfClass:[ORCAction class]]);
}

- (void)test_init_action_scanner_with_json
{

    NSDictionary *json = [self jsonFromFileName:@"GET_action_scanner_without_schedule"];
    
    ORCAction *action = [[ORCAction alloc] initWithJSON:json];
    XCTAssertNotNil(action);
    XCTAssertTrue([action isKindOfClass:[ORCActionScanner class]]);
}

- (void)test_init_action_browser_with_json
{
    NSDictionary *json = [self jsonFromFileName:@"GET_action_browser_without_schedule"];

    ORCAction *action = [[ORCAction alloc] initWithJSON:json];
    XCTAssertNotNil(action);
    XCTAssertTrue([action isKindOfClass:[ORCActionBrowser class]]);
}

- (void)test_init_action_webview_with_json
{
    NSDictionary *json = [self jsonFromFileName:@"GET_action_webview_without_schedule"];
    
    ORCAction *action = [[ORCAction alloc] initWithJSON:json];
    XCTAssertNotNil(action);
    XCTAssertTrue([action isKindOfClass:[ORCActionWebView class]]);
}

- (void)test_toDictionary_whereActionHasAllValues
{
    
    NSDictionary *resultActionDictionary = @{@"type" : @"webview",
                                             @"trackId" : @"trackId",
                                             @"title" : @"Title",
                                             @"body" : @"Body",
                                             @"seconds" : @60,
                                             @"cancelable" : @YES,
                                             @"url" : @"http://www.gigigo.com",
                                             @"launchedById" : @"code"};
    
    ORCAction *action = [[ORCAction alloc] init];
    action.type = @"webview";
    action.trackId = @"trackId";
    action.urlString = @"http://www.gigigo.com";
    action.titleNotification = @"Title";
    action.bodyNotification = @"Body";
    action.scheduleTime = 60;
    action.cancelable = YES;
    action.launchedByTriggerCode = @"code";
    
    NSDictionary *actionDictionary = [action toDictionary];
    XCTAssertTrue([actionDictionary isEqualToDictionary:resultActionDictionary]);
}

#pragma mark - Helper

- (NSDictionary *)jsonFromFileName:(NSString *)fileName
{
    NSString *path = [self.testBundle pathForResource:fileName ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    return json;
}

@end
