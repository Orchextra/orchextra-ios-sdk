//
//  GIGParseClassTests.m
//  GiGLibrary
//
//  Created by  Eduardo Parada on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GIGParseClass.h"

#import "GIGMockClassEmpty.h"
#import "GIGMockClassNull.h"
#import "GIGMockClassPrimitive.h"
#import "GIGMockClassNSObject.h"
#import "GIGMockClassUser.h"


@interface GIGParseClassTests : XCTestCase

@property (strong, nonatomic) GIGMockClassEmpty *mockEmpty;
@property (strong, nonatomic) GIGMockClassNull *mockNull;
@property (strong, nonatomic) GIGMockClassPrimitive *mockPrimitive;
@property (strong, nonatomic) GIGMockClassNSObject *mockNSObject;
@property (strong, nonatomic) GIGMockClassUser *mockExample;

@end


@implementation GIGParseClassTests

- (void)setUp
{
    [super setUp];
    
    self.mockEmpty = [[GIGMockClassEmpty alloc] init];
    self.mockNull = [[GIGMockClassNull alloc] init];
    self.mockPrimitive = [[GIGMockClassPrimitive alloc] init];
    self.mockNSObject = [[GIGMockClassNSObject alloc] init];
    self.mockExample = [[GIGMockClassUser alloc] init];
}

- (void)tearDown
{
    self.mockEmpty = nil;
    self.mockNull = nil;
    self.mockPrimitive = nil;
    self.mockNSObject = nil;
    self.mockExample = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_calculate_size
{
    NSDictionary *dicEmpty = [GIGParseClass parseClass:self.mockEmpty];
    XCTAssertTrue(dicEmpty.count == 0);
    
    NSDictionary *dicNull = [GIGParseClass parseClass:self.mockNull];
    XCTAssertTrue(dicNull.count == 1);
    
    NSDictionary *dicPrimitive = [GIGParseClass parseClass:self.mockPrimitive];
    XCTAssertTrue(dicPrimitive.count == 6);
    
    NSDictionary *dicNSObject = [GIGParseClass parseClass:self.mockNSObject];
    XCTAssertTrue(dicNSObject.count == 2);
    
    NSDictionary *dicExample = [GIGParseClass parseClass:self.mockExample];
    XCTAssertTrue(dicExample.count == 5);
}

- (void)test_empty_properties
{
    NSDictionary *dicEmpty = [GIGParseClass parseClass:self.mockEmpty];
    XCTAssertTrue(dicEmpty != nil);
    XCTAssertTrue(dicEmpty.count == 0);
    
    NSDictionary *dicNull = [GIGParseClass parseClass:self.mockNull];
    XCTAssertTrue(dicNull != nil);
    XCTAssertTrue(dicNull.count > 0);
    
    NSDictionary *dicPrimitive = [GIGParseClass parseClass:self.mockPrimitive];
    XCTAssertTrue(dicPrimitive != nil);
    XCTAssertTrue(dicPrimitive.count > 0);
}

- (void)test_null
{
    NSDictionary *dicNull = [GIGParseClass parseClass:self.mockNull];
    XCTAssertTrue(dicNull[@"textNull"] == [NSNull null]);
    
    NSDictionary *dicPrimitive = [GIGParseClass parseClass:self.mockPrimitive];
    XCTAssertFalse(dicPrimitive[@"intPrimitive"] == [NSNull null]);
    
    NSDictionary *dicNSObject = [GIGParseClass parseClass:self.mockNSObject];
    XCTAssertFalse(dicNSObject[@"stringNSObject"] == [NSNull null]);
}

- (void)test_recover_data
{
    NSDictionary *dicEmpty = [GIGParseClass parseClass:self.mockEmpty];
    XCTAssertTrue(dicEmpty[@"someThing"] == nil);
    
    NSDictionary *dicNull = [GIGParseClass parseClass:self.mockNull];
    XCTAssertTrue(dicNull[@"textNull"] == [NSNull null]);
    
    NSDictionary *dicPrimitive = [GIGParseClass parseClass:self.mockPrimitive];
    XCTAssertTrue([dicPrimitive[@"intPrimitive"] intValue] == INT_MAX);
    XCTAssertTrue([dicPrimitive[@"longPrimitive"] longValue] == LONG_MAX);
    XCTAssertTrue([dicPrimitive[@"floatPrimitive"] floatValue] == 123.432f);
    XCTAssertTrue([dicPrimitive[@"doublePrimitive"] doubleValue] == -21.09);
    XCTAssertTrue([dicPrimitive[@"boolPrimitive"] boolValue] == YES);
    XCTAssertTrue([dicPrimitive[@"charPrimitive"] charValue] == 'a');
    
    NSDictionary *dicNSObject = [GIGParseClass parseClass:self.mockNSObject];
    XCTAssertTrue([dicNSObject[@"stringNSObject"] isEqualToString:@"NSstring text"]);
    XCTAssertTrue([dicNSObject[@"integerNSObject"] integerValue] == INT_MAX);
}

- (void)test_example
{
    GIGParseClass *parseExample = [[GIGParseClass alloc] init];
    NSDictionary *dicExample = [parseExample parseClass:self.mockExample];
    XCTAssertTrue([dicExample[@"name"] isEqualToString:@"Edu"]);
    XCTAssertTrue([dicExample[@"lastName"] isEqualToString:@""]);
    XCTAssertTrue(dicExample[@"secondLastName"] == [NSNull null]);
    XCTAssertTrue([dicExample[@"age"] intValue] == 20);
    
    GIGMockClassAddress *address = (GIGMockClassAddress *)dicExample[@"address"];
    NSDictionary *dicAddress = [GIGParseClass parseClass:address];
    XCTAssertTrue([dicAddress[@"street"] isEqualToString:@"Calle doctor Zamenhoft"]);
    XCTAssertTrue([dicAddress[@"number"] intValue] == 36);
    XCTAssertTrue([dicAddress[@"city"] isEqualToString:@""]);
    XCTAssertTrue(dicAddress[@"country"] == [NSNull null]);
}
@end

