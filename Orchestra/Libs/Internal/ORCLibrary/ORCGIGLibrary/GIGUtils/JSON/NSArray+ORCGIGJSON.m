//
//  NSArray+GIGJSON.m
//  giglibrary
//
//  Created by Sergio Baró on 10/17/13.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "NSArray+ORCGIGJSON.h"


@implementation NSArray (ORCGIGJSON)

- (NSString *)toJSONString
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error)
    {
        NSLog(@"%@", error.localizedDescription);
        return @"";
    }
    else
    {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (NSData *)toData
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    
    if (error)
    {
        NSLog(@"%@", error.localizedDescription);
        return nil;
    }
    
    return data;
}

@end
