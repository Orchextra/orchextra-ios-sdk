//
//  NSData+GIGJSON.m
//  giglibrary
//
//  Created by Sergio Baró on 10/25/13.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "NSData+ORCGIGJSON.h"


@implementation NSData (ORCGIGJSON)

- (id)toJSON
{
    NSError *error = nil;
    id json = [self toJSONError:&error];
    if (error)
    {
        NSLog(@"%@", error.localizedDescription);
    }
    
    return json;
}

- (id)toJSONError:(NSError **)error
{
    return [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:error];
}

@end
