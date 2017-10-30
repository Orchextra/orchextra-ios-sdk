//
//  GIGURLRequestLogger.h
//  gignetwork
//
//  Created by Sergio Baró on 06/03/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GIGConstants.h"


@interface GIGURLRequestLogger : NSObject

@property (assign, nonatomic) GIGLogLevel logLevel;
@property (strong, nonatomic) NSString *tag;

- (void)logRequest:(NSURLRequest *)request encoding:(NSStringEncoding)stringEncoding;
- (void)logResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *)error stringEncoding:(NSStringEncoding)stringEncoding;

@end
