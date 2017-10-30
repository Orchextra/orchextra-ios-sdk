//
//  GIGDigest.h
//  giglibrary
//
//  Created by Sergio Baró on 10/04/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GIGDigest : NSObject

+ (NSString *)MD5:(id)data; // NSString or NSData
+ (NSString *)SHA1:(id)data; // NSString or NSData
+ (NSString *)SHA256:(id)data; // NSString or NSData
+ (NSString *)SHA512:(id)data; // NSString or NSData

@end
