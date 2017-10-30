//
//  GIGURLDomain.m
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLDomain.h"


@implementation GIGURLDomain

+ (NSArray *)domainsWithJSON:(NSArray *)domainsJSON
{
    NSMutableArray *domains = [[NSMutableArray alloc] initWithCapacity:domainsJSON.count];
    for (NSDictionary *domainJSON in domainsJSON)
    {
        GIGURLDomain *domain = [[GIGURLDomain alloc] initWithJSON:domainJSON];
        [domains addObject:domain];
    }
    
    return [domains copy];
}

- (instancetype)initWithJSON:(NSDictionary *)json
{
    NSString *name = json[@"name"];
    NSString *url = json[@"url"];
    
    return [self initWithName:name url:url];
}

- (instancetype)initWithName:(NSString *)name url:(NSString *)url
{
    self = [super init];
    if (self)
    {
        _name = name;
        _url = url;
    }
    return self;
}

#pragma mark - PUBLIC

- (BOOL)isEqualToDomain:(GIGURLDomain *)domain
{
    if (![domain isKindOfClass:self.class]) return NO;
    
    return ([domain.name isEqualToString:self.name] && [domain.url isEqualToString:self.url]);
}

#pragma mark - OVERRIDE

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", [super description], self.name];
}

#pragma mark - PRIVATE

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _url = [aDecoder decodeObjectForKey:@"url"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_url forKey:@"url"];
}

@end
