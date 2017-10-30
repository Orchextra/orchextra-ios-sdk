//
//  GIGURLImageResponseTests.m
//  GIGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGURLImageResponse.h"
#import "UIImage+GIGExtension.h"


@interface GIGURLImageResponseTests : XCTestCase

@end

@implementation GIGURLImageResponseTests

- (void)test_init_with_nil_data
{
    GIGURLImageResponse *response = [[GIGURLImageResponse alloc] initWithData:nil];
    
    XCTAssertFalse(response.success);
    XCTAssertNil(response.data);
    XCTAssertNil(response.image);
}

- (void)test_init_with_non_image_data
{
    NSData *stringData = [@"I'm not an image" dataUsingEncoding:NSUTF8StringEncoding];
    GIGURLImageResponse *response = [[GIGURLImageResponse alloc] initWithData:stringData];
    
    XCTAssertFalse(response.success);
    XCTAssertNil(response.image);
    XCTAssertNotNil(response.data);
}

- (void)test_init_with_image_data
{
    UIImage *image = [UIImage imageWithColor:[UIColor blackColor]];
    NSData *data = UIImagePNGRepresentation(image);
    
    GIGURLImageResponse *response = [[GIGURLImageResponse alloc] initWithData:data];
    
    XCTAssertTrue(response.success);
    XCTAssertNotNil(response.image);
    XCTAssertTrue([response.data isEqual:data]);
}

- (void)test_init_with_image
{
    UIImage *image = [UIImage imageWithColor:[UIColor blackColor]];
    
    GIGURLImageResponse *response = [[GIGURLImageResponse alloc] initWithImage:image];
    XCTAssertTrue(response.success);
    XCTAssertNotNil(response.data);
    XCTAssertNotNil(response.image);
}

- (void)test_init_with_nil_image
{
    GIGURLImageResponse *response = [[GIGURLImageResponse alloc] initWithImage:nil];
    
    XCTAssertFalse(response.success);
    XCTAssertNil(response.image);
    XCTAssertNil(response.data);
}

@end
