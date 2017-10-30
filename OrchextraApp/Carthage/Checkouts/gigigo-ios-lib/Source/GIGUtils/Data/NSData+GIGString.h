//
//  NSData+GIGString.h
//  giglibrary
//
//  Created by Sergio Baró on 10/25/13.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (GIGString)

- (NSString *)toStringWithEncoding:(NSStringEncoding)encoding;
- (NSString *)toUTF8String;
- (NSString *)toASCIIString;

@end
