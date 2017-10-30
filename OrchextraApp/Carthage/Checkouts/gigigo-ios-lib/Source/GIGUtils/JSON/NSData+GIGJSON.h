//
//  NSData+GIGJSON.h
//  giglibrary
//
//  Created by Sergio Baró on 10/25/13.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (GIGJSON)

- (id)toJSON;
- (id)toJSONError:(NSError **)error;

@end
