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
            [ORCLog logVerbose:@"-- REQUEST: %@ --", self.tag ?: @""];
            [ORCLog logVerbose:@"URL: %@", request.URL.absoluteString];
            [ORCLog logVerbose:@"Method: %@", request.HTTPMethod];
            [ORCLog logVerbose:@"Headers: %@", request.allHTTPHeaderFields];
            [self logBody:request.HTTPBody stringEncoding:stringEncoding];
            break;
        }
        case GIGLogLevelBasic:
        {
            [ORCLog logVerbose:@"-- REQUEST: %@ --", self.tag ?: @""];
            [ORCLog logVerbose:@"URL: %@", request.URL.absoluteString];
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
            [ORCLog logVerbose:@"-- RESPONSE: %@ --", self.tag ?: @""];
            [ORCLog logVerbose:@"URL: %@", response.URL.absoluteString];
            [ORCLog logVerbose:@"Status Code: %d", (int)response.statusCode];
            [ORCLog logVerbose:@"Headers: %@", response.allHeaderFields];
            [self logBody:data stringEncoding:stringEncoding];
            [self logError:error];
            break;
        }
        case GIGLogLevelBasic:
        {
            [ORCLog logVerbose:@"-- RESPONSE: %@ --", self.tag ?: @""];
            [ORCLog logVerbose:@"URL: %@", response.URL.absoluteString];
            [ORCLog logVerbose:@"Status Code: %d", (int)response.statusCode];
            [self logBody:data stringEncoding:stringEncoding];
            break;
        }
        case GIGLogLevelError:
        {
            [ORCLog logVerbose:@"-- RESPONSE: %@ --", self.tag ?: @""];
            [ORCLog logVerbose:@"URL: %@", response.URL.absoluteString];
            [ORCLog logVerbose:@"Status Code: %d", (int)response.statusCode];
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
    [ORCLog logVerbose:@"Body (%d): %@", (int)body.length, dataString ?: @""];
}

- (void)logError:(NSError *)error
{
    if (error != nil)
    {
        [ORCLog logError:@"Error (%d): %@", (int)error.code, error.localizedDescription];
        if (error.userInfo)
        {
            [ORCLog logError:@"%@", error.userInfo];
        }
    }
}

@end
