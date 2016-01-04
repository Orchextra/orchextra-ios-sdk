//
//  ORCURLRequest.m
//  Orchestra
//
//  Created by Judith Medina on 25/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCURLRequest.h"
#import "ORCConstants.h"


@implementation ORCURLRequest

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url
{
    self = [super initWithMethod:method url:url];
    
    if (self)
    {
        self.headers = [self addPrefixHeader];
    }
    
    return self;
}

- (void)send
{
    self.headers = [self addPrefixHeader];
    [super send];
}

- (NSDictionary *)addPrefixHeader
{
    NSString *headerPrefix = [self headerPrefix];
    
    if (headerPrefix)
    {
        NSMutableDictionary *tmp = (self.headers) ? [self.headers mutableCopy] : [NSMutableDictionary new];
        [tmp addEntriesFromDictionary: @{@"X-app-sdk" : headerPrefix}];
        [tmp addEntriesFromDictionary:@{@"Accept-Language" : [[NSLocale currentLocale] localeIdentifier]}];
        return tmp;
    }
    
    return nil;
}

- (NSString *)headerPrefix
{
    return [NSString stringWithFormat:@"IOS_%@", ORCSDKVersion];
}


@end
