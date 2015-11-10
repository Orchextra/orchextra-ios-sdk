//
//  GIGURLFormatter.m
//  giglibrary
//
//  Created by Sergio Baró on 14/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLFormatter.h"

#import "NSString+ORCGIGRegexp.h"


@implementation ORCGIGURLFormatter

- (NSString *)formatUrl:(NSString *)url withProtocol:(NSString *)protocol
{
    if (url.length == 0) return [NSString stringWithFormat:@"%@://", protocol];
    
    NSArray *matches = [url matches:@"^https?://(.*)"];
    if (matches.count > 0)
    {
        url = matches[0];
    }
    
    return [NSString stringWithFormat:@"%@://%@", protocol, url];
}

@end
