//
//  GIGURLDomain.h
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GIGURLDomain : NSObject
<NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;

+ (NSArray *)domainsWithJSON:(NSArray *)domainsJSON;

- (instancetype)initWithJSON:(NSDictionary *)json;
- (instancetype)initWithName:(NSString *)name url:(NSString *)url;

- (BOOL)isEqualToDomain:(GIGURLDomain *)domain;

@end
