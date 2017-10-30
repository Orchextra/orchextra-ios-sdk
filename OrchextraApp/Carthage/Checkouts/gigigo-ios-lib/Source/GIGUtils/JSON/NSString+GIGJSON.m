//
//  NSString+GIGJSON.m
//  giglibrary
//
//  Created by Sergio Baró on 10/17/13.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "NSString+GIGJSON.h"


@implementation NSString (GIGJSON)

- (id)toJSON
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error)
    {
        NSLog(@"%@", error.localizedDescription);
    }
    
    return json;
}

@end
