//
//  GIGURLRequestLogger.m
//  gignetwork
//
//  Created by Sergio Baró on 06/03/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLRequestLogger.h"

@implementation ORCGIGURLRequestLogger

#pragma mark - PUBLIC

- (void)logRequest:(NSURLRequest *)request encoding:(NSStringEncoding)stringEncoding
{
    switch (self.logLevel)
    {
        case GIGLogLevelVerbose:
        {
            [[ORCLog sharedInstance] logVerbose:@"-- REQUEST: %@ --", self.tag ?: @""];
            [[ORCLog sharedInstance] logVerbose:@"URL: %@", request.URL.absoluteString];
            [[ORCLog sharedInstance] logVerbose:@"Method: %@", request.HTTPMethod];
            [[ORCLog sharedInstance] logVerbose:@"Headers: %@", request.allHTTPHeaderFields];
            [self logBody:request.HTTPBody stringEncoding:stringEncoding];
            break;
        }
        case GIGLogLevelBasic:
        {
            [[ORCLog sharedInstance] logVerbose:@"-- REQUEST: %@ --", self.tag ?: @""];
            [[ORCLog sharedInstance] logVerbose:@"URL: %@", request.URL.absoluteString];
            [self logBody:request.HTTPBody stringEncoding:stringEncoding];
            break;
        }
        case GIGLogLevelError:
        case GIGLogLevelNone:
            // DO NOTHING
            break;
    }
}

- (void)logResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *)error stringEncoding:(NSStringEncoding)stringEncoding
{
    switch (self.logLevel)
    {
        case GIGLogLevelVerbose:
        {
            [[ORCLog sharedInstance] logVerbose:@"-- RESPONSE: %@ --", self.tag ?: @""];
            [[ORCLog sharedInstance] logVerbose:@"URL: %@", response.URL.absoluteString];
            [[ORCLog sharedInstance] logVerbose:@"Status Code: %d", (int)response.statusCode];
            [[ORCLog sharedInstance] logVerbose:@"Headers: %@", response.allHeaderFields];
            [self logBody:data stringEncoding:stringEncoding];
            [self logError:error];
            break;
        }
        case GIGLogLevelBasic:
        {
            [[ORCLog sharedInstance] logVerbose:@"-- RESPONSE: %@ --", self.tag ?: @""];
            [[ORCLog sharedInstance] logVerbose:@"URL: %@", response.URL.absoluteString];
            [[ORCLog sharedInstance] logVerbose:@"Status Code: %d", (int)response.statusCode];
            [self logBody:data stringEncoding:stringEncoding];
            break;
        }
        case GIGLogLevelError:
        {
            [[ORCLog sharedInstance] logVerbose:@"-- RESPONSE: %@ --", self.tag ?: @""];
            [[ORCLog sharedInstance] logVerbose:@"URL: %@", response.URL.absoluteString];
            [[ORCLog sharedInstance] logVerbose:@"Status Code: %d", (int)response.statusCode];
            [self logError:error];
            break;
        }
        case GIGLogLevelNone:
            // DO NOTHING
            break;
    }
}

#pragma mark - PRIVATE

- (void)logBody:(NSData *)body stringEncoding:(NSStringEncoding)stringEncoding
{
    NSString *dataString = [[NSString alloc] initWithData:body encoding:stringEncoding];
    [[ORCLog sharedInstance] logVerbose:@"Body (%d): %@", (int)body.length, dataString ?: @""];
}

- (void)logError:(NSError *)error
{
    if (error != nil)
    {
        [[ORCLog sharedInstance] logError:@"Error (%d): %@", (int)error.code, error.localizedDescription];
        if (error.userInfo)
        {
            [[ORCLog sharedInstance] logError:@"%@", error.userInfo];
        }
    }
}

@end
