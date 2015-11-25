//
//  GIGURLRequestLogger.m
//  gignetwork
//
//  Created by Sergio Baró on 06/03/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLRequestLogger.h"
#import "ORCGIGLogManager.h"

@implementation ORCGIGURLRequestLogger

#pragma mark - PUBLIC

- (void)logRequest:(NSURLRequest *)request encoding:(NSStringEncoding)stringEncoding
{
    switch (self.logLevel)
    {
        case GIGLogLevelVerbose:
        {
            [ORCGIGLogManager log:@"-- REQUEST: %@ --", self.tag ?: @""];
            [ORCGIGLogManager log:@"URL: %@", request.URL.absoluteString];
            [ORCGIGLogManager log:@"Method: %@", request.HTTPMethod];
            [ORCGIGLogManager log:@"Headers: %@", request.allHTTPHeaderFields];
            [self logBody:request.HTTPBody stringEncoding:stringEncoding];
            break;
        }
        case GIGLogLevelBasic:
        {
            [ORCGIGLogManager log:@"-- REQUEST: %@ --", self.tag ?: @""];
            [ORCGIGLogManager log:@"URL: %@", request.URL.absoluteString];
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
            [ORCGIGLogManager log:@"-- RESPONSE: %@ --", self.tag ?: @""];
            [ORCGIGLogManager log:@"URL: %@", response.URL.absoluteString];
            [ORCGIGLogManager log:@"Status Code: %d", (int)response.statusCode];
            [ORCGIGLogManager log:@"Headers: %@", response.allHeaderFields];
            [self logBody:data stringEncoding:stringEncoding];
            [self logError:error];
            break;
        }
        case GIGLogLevelBasic:
        {
            [ORCGIGLogManager log:@"-- RESPONSE: %@ --", self.tag ?: @""];
            [ORCGIGLogManager log:@"URL: %@", response.URL.absoluteString];
            [ORCGIGLogManager log:@"Status Code: %d", (int)response.statusCode];
            break;
        }
        case GIGLogLevelError:
        {
            [ORCGIGLogManager log:@"-- RESPONSE: %@ --", self.tag ?: @""];
            [ORCGIGLogManager log:@"URL: %@", response.URL.absoluteString];
            [ORCGIGLogManager log:@"Status Code: %d", (int)response.statusCode];
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
    [ORCGIGLogManager log:@"Body (%d): %@", (int)body.length, dataString ?: @""];
}

- (void)logError:(NSError *)error
{
    if (error != nil)
    {
        [ORCGIGLogManager log:@"Error (%d): %@", (int)error.code, error.localizedDescription];
        if (error.userInfo)
        {
            [ORCGIGLogManager log:@"%@", error.userInfo];
        }
    }
}

@end
