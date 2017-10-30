//
//  GIGDocumentValidatorTests.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGDocumentValidator.h"


@interface GIGDocumentValidatorTests : XCTestCase

@property (strong, nonatomic) GIGDocumentValidator *validator;

@end

@implementation GIGDocumentValidatorTests

- (void)setUp
{
    [super setUp];
    
    self.validator = [[GIGDocumentValidator alloc] init];
}

- (void)tearDown
{
    self.validator = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_valid_documents
{
    XCTAssertTrue([self.validator validate:@"12345678A" error:nil]); // DNI
    XCTAssertTrue([self.validator validate:@"X1234567A" error:nil]); // NIE
    XCTAssertTrue([self.validator validate:@"A12345678" error:nil]); // CIF
}

- (void)test_invalid_documents
{
    XCTAssertFalse([self.validator validate:@"123456789" error:nil]);
    XCTAssertFalse([self.validator validate:@"fjdslfj" error:nil]);
    XCTAssertFalse([self.validator validate:@"73498437" error:nil]);
    XCTAssertFalse([self.validator validate:@"X12345678B" error:nil]);
    XCTAssertFalse([self.validator validate:@"7540882X" error:nil]);
}

@end
