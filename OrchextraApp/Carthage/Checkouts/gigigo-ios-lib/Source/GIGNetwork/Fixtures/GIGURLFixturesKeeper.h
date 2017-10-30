//
//  GIGURLFixturesKeeper.h
//  giglibrary
//
//  Created by Sergio Baró on 15/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GIGURLFixture.h"

@class GIGURLStorage;


static NSString * const GIGURLFixturesKeeperDefaultFile = @"fixtures.json";


@interface GIGURLFixturesKeeper : NSObject

@property (assign, nonatomic) BOOL useFixture;
@property (strong, nonatomic) GIGURLFixture *currentFixture;
@property (strong, nonatomic) NSArray *fixtures;

- (instancetype)initWithStorage:(GIGURLStorage *)storage;

- (NSData *)mockForRequestTag:(NSString *)requestTag;
- (NSData *)mockWithFilename:(NSString *)mockFileName;
- (BOOL)isMockDefinedForRequestTag:(NSString *)requestTag;

@end
