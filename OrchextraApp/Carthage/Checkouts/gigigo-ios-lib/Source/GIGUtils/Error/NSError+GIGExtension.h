//
//  NSError+GIGExtension.h
//  giglibrary
//
//  Created by Sergio Baró on 09/04/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSError (GIGExtension)

+ (instancetype)errorWithMessage:(NSString *)message;
+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message;
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)message;

@end
