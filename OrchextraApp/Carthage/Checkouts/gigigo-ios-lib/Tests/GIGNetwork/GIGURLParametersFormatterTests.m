//
//  GIGURLParametersFormatterTests.m
//  gignetwork
//
//  Created by Sergio Baró on 25/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGURLParametersFormatter.h"
#import "GIGURLFile.h"


@interface GIGURLParametersFormatterTests : XCTestCase

@property (strong, nonatomic) GIGURLParametersFormatter *builder;

@end


@implementation GIGURLParametersFormatterTests

- (void)setUp
{
    [super setUp];
    
    self.builder = [[GIGURLParametersFormatter alloc] init];
}

- (void)tearDown
{
    self.builder = nil;
    
    [super tearDown];
}

#pragma mark - TESTS (Boundary Generation)

- (void)test_Boundary_should_have_a_explicit_length
{
    NSString *boundary = [self.builder generateBoundary];
    
    XCTAssertNotNil(boundary);
    XCTAssertTrue(boundary.length == 51, @"%d", (int)boundary.length);
}

- (void)test_Boundary_should_be_random
{
    NSMutableArray *boundaries = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 1000; i++)
    {
        NSString *boundary = [self.builder generateBoundary];
        
        XCTAssertFalse([boundaries containsObject:boundary]);
        [boundaries addObject:boundary];
    }
}

#pragma mark - TESTS (QueryString)

- (void)test_QueryString_with_no_parameters
{
    NSString *queryString = [self.builder queryStringWithParameters:nil];
    XCTAssertTrue(queryString.length == 0);
    
    queryString = [self.builder queryStringWithParameters:@{}];
    XCTAssertTrue(queryString.length == 0);
}

- (void)test_QueryString_with_one_parameter
{
    NSDictionary *parameters = @{@"key":@"value"};
    
    NSString *queryString = [self.builder queryStringWithParameters:parameters];
    XCTAssertTrue([queryString isEqualToString:@"key=value"], @"%@", queryString);
}

- (void)test_QueryString_with_two_parameters
{
    NSDictionary *parameters = @{@"key":@"value", @"key2":@"value2"};
    
    NSString *queryString = [self.builder queryStringWithParameters:parameters];
    XCTAssertTrue([queryString isEqualToString:@"key=value&key2=value2"], @"%@", queryString);
}

- (void)test_QueryString_paremeter_with_no_value
{
    NSDictionary *parameters = @{@"key":@""};
    
    NSString *queryString = [self.builder queryStringWithParameters:parameters];
    XCTAssertTrue([queryString isEqualToString:@"key="], @"%@", queryString);
}

- (void)test_QueryString_paremeter_with_no_key
{
    NSDictionary *parameters = @{@"":@"value"};
    
    NSString *queryString = [self.builder queryStringWithParameters:parameters];
    XCTAssertTrue(queryString.length == 0, @"%@", queryString);
}

- (void)test_QueryString_encoding
{
    NSDictionary *parameters = @{@"search":@"texto de la búsqueda"};
    
    NSString *queryString = [self.builder queryStringWithParameters:parameters];
    XCTAssertTrue([queryString isEqualToString:@"search=texto%20de%20la%20b%C3%BAsqueda"], @"%@", queryString);
}

- (void)test_QueryString_number_parameter
{
    NSDictionary *parameters = @{@"number":@(23)};
    
    NSString *queryString = [self.builder queryStringWithParameters:parameters];
    XCTAssertTrue([queryString isEqualToString:@"number=23"], @"%@", queryString);
}

- (void)test_QueryString_date_parameter
{
    NSDictionary *parameter = @{@"date": [NSDate date]};
    
    NSString *queryString = [self.builder queryStringWithParameters:parameter];
    XCTAssertTrue([queryString isEqualToString:@"date="], @"%@", queryString);
}

#pragma mark - TESTS (URL)

- (void)test_Url_with_no_parameters_no_url
{
    NSURL *URL = [self.builder URLWithParameters:nil baseUrl:nil];
    
    XCTAssertNil(URL);
}

- (void)test_Url_with_no_parameters
{
    NSString *url = @"http://www.gigigo.com";
    
    NSURL *URL = [self.builder URLWithParameters:nil baseUrl:url];
    XCTAssertTrue([URL.absoluteString isEqualToString:url], @"%@", URL);
    
    URL = [self.builder URLWithParameters:@{} baseUrl:url];
    XCTAssertTrue([URL.absoluteString isEqualToString:url], @"%@", URL);
}

#pragma mark - TESTS (Body)

- (void)test_Body_with_no_parameters_no_files
{
    NSData *body = [self.builder bodyWithParameters:nil];
    XCTAssertNil(body);
    
    body = [self.builder bodyWithParameters:@{}];
    XCTAssertNil(body);
}

- (void)test_Body_with_one_parameter_no_files
{
    NSDictionary *parameters = @{@"key":@"value"};
    NSData *body = [self.builder bodyWithParameters:parameters];
    
    XCTAssertNotNil(body);
    NSString *bodyString = [[NSString alloc] initWithData:body encoding:self.builder.stringEncoding];
    XCTAssertTrue([bodyString isEqualToString:@"key=value"], @"%@", bodyString);
}

- (void)test_Body_with_one_file
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [[UIColor blackColor] setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    GIGURLFile *file = [[GIGURLFile alloc] init];
    file.data = UIImagePNGRepresentation(image);
    file.parameterName = @"file";
    file.fileName = @"image.png";
    file.mimeType = @"image/png";
    
    NSString *boundary = [self.builder generateBoundary];
    NSData *body = [self.builder multipartBodyWithParameters:nil files:@[file] boundary:boundary];
    
    XCTAssertNotNil(body);
    
    NSRange fileRange = [body rangeOfData:file.data options:kNilOptions range:NSMakeRange(0, body.length)];
    XCTAssertTrue(fileRange.location != NSNotFound);
    XCTAssertTrue(fileRange.length == file.data.length);
    
    NSData *initialBody = [body subdataWithRange:NSMakeRange(0, fileRange.location - 1)];
    NSString *initialBodyString = [[NSString alloc] initWithData:initialBody encoding:self.builder.stringEncoding];
    XCTAssertNotNil(initialBodyString);
    
    CGFloat finalBodyLocation = fileRange.location + fileRange.length;
    NSData *finalBody = [body subdataWithRange:NSMakeRange(finalBodyLocation, body.length - finalBodyLocation)];
    NSString *finalBodyString = [[NSString alloc] initWithData:finalBody encoding:self.builder.stringEncoding];
    XCTAssertNotNil(finalBodyString);
}

#pragma mark - TESTS (JSON)

- (void)test_JSON_with_no_parameters
{
    NSData *body = [self.builder jsonBodyWithParameters:nil error:nil];
    XCTAssertNil(body);
    
    body = [self.builder jsonBodyWithParameters:@{} error:nil];
    XCTAssertNil(body);
}

- (void)test_JSON_with_one_parameter
{
    NSDictionary *parameters = @{@"key":@"value"};
    
    NSError *error = nil;
    NSData *body = [self.builder jsonBodyWithParameters:parameters error:&error];
    
    XCTAssertNil(error);
    XCTAssertNotNil(body);
    
    NSString *stringBody = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    XCTAssertTrue([stringBody isEqualToString:@"{\"key\":\"value\"}"], @"%@", stringBody);
}

@end
