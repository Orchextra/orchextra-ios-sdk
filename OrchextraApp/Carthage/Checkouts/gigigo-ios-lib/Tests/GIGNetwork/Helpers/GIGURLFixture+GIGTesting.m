//
//  GIGURLFixture+GIGTesting.m
//  giglibrary
//
//  Created by Sergio Baró on 15/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLFixture+GIGTesting.h"


@implementation GIGURLFixture (GIGTesting)

+ (NSArray *)buildFixtures:(NSInteger)numberOfFixtures
{
    NSMutableArray *fixtures = [[NSMutableArray alloc] initWithCapacity:numberOfFixtures];
    
    for (int i = 0; i < numberOfFixtures; i++)
    {
        NSString *name = [NSString stringWithFormat:@"fixture%d", (i + 1)];
        NSDictionary *mocks = @{@"requestTag": @"mockFile"};
        GIGURLFixture *fixture = [[GIGURLFixture alloc] initWithName:name mocks:mocks];
        
        [fixtures addObject:fixture];
    }
    
    return [fixtures copy];
}

@end
