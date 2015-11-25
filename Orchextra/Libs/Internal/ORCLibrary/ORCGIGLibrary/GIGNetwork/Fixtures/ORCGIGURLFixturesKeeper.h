//
//  GIGURLFixturesKeeper.h
//  giglibrary
//
//  Created by Sergio Baró on 15/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ORCGIGURLFixture.h"

@class ORCGIGURLStorage;


static NSString * const GIGURLFixturesKeeperDefaultFile = @"fixtures.json";


@interface ORCGIGURLFixturesKeeper : NSObject

@property (assign, nonatomic) BOOL useFixture;
@property (strong, nonatomic) ORCGIGURLFixture *currentFixture;
@property (strong, nonatomic) NSArray *fixtures;

- (instancetype)initWithStorage:(ORCGIGURLStorage *)storage;

- (void)loadFixturesFromFile:(NSString *)fixtureFilename;
- (NSData *)mockForRequestTag:(NSString *)requestTag;

@end
