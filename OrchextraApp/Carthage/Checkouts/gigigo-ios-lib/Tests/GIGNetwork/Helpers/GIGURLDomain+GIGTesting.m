//
//  GIGURLDomain+GIGTesting.m
//  giglibrary
//
//  Created by Sergio Baró on 14/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLDomain+GIGTesting.h"


@implementation GIGURLDomain (GIGTesting)

+ (NSArray *)buildDomains:(NSInteger)numberOfDomains
{
    NSMutableArray *domains = [[NSMutableArray alloc] initWithCapacity:numberOfDomains];
    
    for (int i = 0; i < numberOfDomains; i++)
    {
        NSString *name = [NSString stringWithFormat:@"domain%d", (i + 1)];
        NSString *url = [NSString stringWithFormat:@"http://url%d", (i + 1)];
        GIGURLDomain *domain = [[GIGURLDomain alloc] initWithName:name url:url];
        
        [domains addObject:domain];
    }
    
    return [domains copy];
}

@end
