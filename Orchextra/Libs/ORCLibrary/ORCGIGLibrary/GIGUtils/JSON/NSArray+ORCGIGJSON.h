//
//  NSArray+GIGJSON.h
//  giglibrary
//
//  Created by Sergio Baró on 10/17/13.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (ORCGIGJSON)

- (NSString *)toJSONString;
- (NSData *)toData;

@end
