//
//  GIGURLFixture.h
//  gignetwork
//
//  Created by Sergio Baró on 07/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GIGURLFixture : NSObject
<NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDictionary *mocks;

+ (NSArray *)fixturesWithJSON:(NSArray *)fixturesJSON bundle:(NSBundle *)bundle;

- (instancetype)initWithJSON:(NSDictionary *)json bundle:(NSBundle *)bundle;
- (instancetype)initWithName:(NSString *)name mocks:(NSDictionary *)mocks;

- (BOOL)isEqualToFixture:(GIGURLFixture *)fixture;

@end
