//
//  NSDictionary+GIGJSON.m
//  giglibrary
//
//  Created by Sergio Baró on 10/17/13.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "NSDictionary+GIGJSON.h"


@implementation NSDictionary (GIGJSON)

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
- (NSInteger)integerForKey:(NSString *)key
{
    id value = self[key];
    
    if ([value isKindOfClass:[NSNumber class]]) return [value integerValue];
    if ([value isKindOfClass:[NSString class]]) return [value integerValue];
    
    return 0;
}

- (int)intForKey:(NSString *)key
{
    NSInteger value = [self integerForKey:key];
    
    return (int)value;
}

- (float)floatForKey:(NSString *)key
{
    id value = self[key];
    
    if ([value isKindOfClass:[NSNumber class]]) return [value floatValue];
    if ([value isKindOfClass:[NSString class]]) return [value floatValue];
    
    return 0.0;
}

- (float)doubleForKey:(NSString *)key
{
    id value = self[key];
    
    if ([value isKindOfClass:[NSNumber class]]) return [value doubleValue];
    if ([value isKindOfClass:[NSString class]]) return [value doubleValue];
    
    return 0.0;
}

- (NSUInteger)unsignedIntegerForKey:(NSString *)key
{
    id value = self[key];
    
    if ([value isKindOfClass:[NSNumber class]]) return [value unsignedIntegerValue];
    if ([value isKindOfClass:[NSString class]]) return [value integerValue];
    
    return 0;
}

- (BOOL)boolForKey:(NSString *)key
{
    id value = self[key];
    
    if ([value isKindOfClass:[NSNumber class]]) return [value boolValue];
    if ([value isKindOfClass:[NSString class]])
    {
        if ([value isEqualToString:@"true"])
        {
            return YES;
        }
        else
        {
            return [(NSString *)value boolValue];
        }
    }

    return NO;
}

- (NSArray *)arrayForKey:(NSString *)key
{
    id value = self[key];
    
    if (![value isKindOfClass:[NSArray class]]) return nil;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id object in (NSArray *)value)
    {
        if (object != [NSNull null])
        {
            [array addObject:object];
        }
    }
    
    return [array copy];
}

- (NSString *)stringForKey:(NSString *)key
{
    id value = self[key];
    
    if ([value isKindOfClass:[NSString class]]) return value;
    if ([value isKindOfClass:[NSNumber class]]) return [NSString stringWithFormat:@"%@", value];
    
    return @"";
}

- (NSString *)stringTrimForKey:(NSString *)key
{
    NSString *value = [self stringForKey:key];
    
    return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key
{
    id value = self[key];
    
    if ([value isKindOfClass:[NSDictionary class]]) return value;
    
    return nil;
}

- (NSTimeInterval)timeIntervalForKey:(NSString *)key
{
    id value = self[key];
    
    if ([value isKindOfClass:[NSNumber class]]) return [value doubleValue];
    if ([value isKindOfClass:[NSString class]]) return [value doubleValue];
    
    return 0.0f;
}

- (NSDate *)dateForKey:(NSString *)key format:(NSString *)format
{
    return [self dateForKey:key format:format locale:nil];
}

- (NSDate *)dateForKey:(NSString *)key format:(NSString *)format locale:(NSLocale *)locale
{
    id value = [self stringForKey:key];
    
    if (value)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = format;
        
        if (locale)
        {
            dateFormatter.locale = locale;
        }
        
        return [dateFormatter dateFromString:value];
    }
    
    return nil;
}

- (NSURL *)URLForKey:(NSString *)key
{
    id value = self[key];
    if (![value isKindOfClass:[NSString class]]) return nil;
    
    return [NSURL URLWithString:(NSString *)value];
}

@end
