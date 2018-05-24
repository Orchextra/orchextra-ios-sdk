//
//  ORCTag.h
//  Orchextra
//
//  Created by Judith Medina on 27/5/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ORCTag : NSObject <NSCoding>

/*
 * The tag prefix information.
 */
@property (strong, nonatomic) NSString *prefix;

/**
 * The tag name information.
 */
@property (strong, nonatomic) NSString *name;

/*
 Init tag with prefix
 @param: prefix
 */
- (instancetype)initWithPrefix:(NSString *)prefix;


/*
 Init tag with prefix and name
 @param: prefix
 @param: name
 */
- (instancetype)initWithPrefix:(NSString *)prefix name:(NSString *)name;

/*
 
 @return: String with the tag or nil
 if the tag does not complain the rules.
 */
- (NSString *)tag;

@end
