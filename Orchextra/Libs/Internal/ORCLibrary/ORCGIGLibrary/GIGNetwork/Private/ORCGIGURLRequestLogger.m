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
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"-- REQUEST: %@ --", self.tag ?: @""]];
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"URL: %@", request.URL.absoluteString]];
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"Method: %@", request.HTTPMethod]];
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"Headers: %@", request.allHTTPHeaderFields]];

            [self logBody:request.HTTPBody stringEncoding:stringEncoding];
            break;
        }
        case GIGLogLevelBasic:
        {
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"-- REQUEST: %@ --", self.tag ?: @""]];
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"URL: %@", request.URL.absoluteString]];
            
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
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"-- RESPONSE: %@ --", self.tag ?: @""]];
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"URL: %@", response.URL.absoluteString]];
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"Status Code: %d", (int)response.statusCode]];
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"Headers: %@", response.allHeaderFields]];
            [self logBody:data stringEncoding:stringEncoding];
            [self logError:error];
            break;
        }
        case GIGLogLevelBasic:
        {
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"-- RESPONSE: %@ --", self.tag ?: @""]];
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"URL: %@", response.URL.absoluteString]];
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"Status Code: %d", (int)response.statusCode]];
            [self logBody:data stringEncoding:stringEncoding];
            break;
        }
        case GIGLogLevelError:
        {
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"-- RESPONSE: %@ --", self.tag ?: @""]];
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"URL: %@", response.URL.absoluteString]];
            [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"Status Code: %d", (int)response.statusCode]];
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
    [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat:@"Body (%d): %@", (int)body.length, dataString ?: @""]];
}

- (void)logError:(NSError *)error
{
    if (error != nil)
    {
        [[ORCLog sharedInstance] logError:[NSString stringWithFormat:@"Error (%d): %@", (int)error.code, error.localizedDescription]];
        if (error.userInfo)
        {
            [[ORCLog sharedInstance] logError:[NSString stringWithFormat:@"%@", error.userInfo]];
        }
    }
}

@end
