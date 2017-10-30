//
//  GIGURLRequestLogger.m
//  gignetwork
//
//  Created by Sergio Baró on 06/03/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLRequestLogger.h"


@implementation GIGURLRequestLogger

#pragma mark - PUBLIC

- (void)logRequest:(NSURLRequest *)request encoding:(NSStringEncoding)stringEncoding
{
    switch (self.logLevel)
    {
        case GIGLogLevelVerbose:
        {
            NSLog(@"-- REQUEST: %@ --", self.tag ?: @"");
            NSLog(@"URL: %@", request.URL.absoluteString);
            NSLog(@"Method: %@", request.HTTPMethod);
            NSLog(@"Headers: %@", request.allHTTPHeaderFields);
            [self logBody:request.HTTPBody stringEncoding:stringEncoding];
            break;
        }
        case GIGLogLevelBasic:
        {
            NSLog(@"-- REQUEST: %@ --", self.tag ?: @"");
            NSLog(@"URL: %@", request.URL.absoluteString);
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
            NSLog(@"-- RESPONSE: %@ --", self.tag ?: @"");
            NSLog(@"URL: %@", response.URL.absoluteString);
            NSLog(@"Status Code: %d", (int)response.statusCode);
            NSLog(@"Headers: %@", response.allHeaderFields);
            [self logBody:data stringEncoding:stringEncoding];
            [self logError:error];
            break;
        }
        case GIGLogLevelBasic:
        {
            NSLog(@"-- RESPONSE: %@ --", self.tag ?: @"");
            NSLog(@"URL: %@", response.URL.absoluteString);
            NSLog(@"Status Code: %d", (int)response.statusCode);
            break;
        }
        case GIGLogLevelError:
        {
            NSLog(@"-- RESPONSE: %@ --", self.tag ?: @"");
            NSLog(@"URL: %@", response.URL.absoluteString);
            NSLog(@"Status Code: %d", (int)response.statusCode);
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
    NSLog(@"Body (%d): %@", (int)body.length, dataString ?: @"");
}

- (void)logError:(NSError *)error
{
    if (error != nil)
    {
        NSLog(@"Error (%d): %@", (int)error.code, error.localizedDescription);
        if (error.userInfo)
        {
            NSLog(@"%@", error.userInfo);
        }
    }
}

@end
