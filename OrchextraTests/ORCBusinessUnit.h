//
//  ORCBusinessUnit.h
//  Orchextra
//
//  Created by Carlos Vicente on 17/6/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ORCBusinessUnit : NSObject <NSCoding>

/**
 * The business unit name information.
 */
@property (strong, nonatomic) NSString *name;

/*
 Init business unit with name
 @param: name
 */
- (instancetype)initWithName:(NSString *)name;

@end
