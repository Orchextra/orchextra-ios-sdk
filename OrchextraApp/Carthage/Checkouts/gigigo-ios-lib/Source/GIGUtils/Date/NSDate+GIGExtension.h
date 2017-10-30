//
//  NSDate+GIGExtension.h
//  giglibrary
//
//  Created by Sergio Baró on 16/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (GIGExtension)

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format locale:(NSLocale *)locale;
+ (NSDate *)randomDate;
+ (NSTimeInterval)timeIntervalSince1970;
+ (NSDate *)yesterday;
+ (NSDate *)afterYesterday;
+ (NSDate *)tomorrow;

- (NSInteger)numberOfDaysFromNow;

- (NSDate *)dateByAddingDays:(NSInteger)days;

- (NSString *)stringWithFormat:(NSString *)dateFormat;
- (NSString *)stringWithFormat:(NSString *)dateFormat locale:(NSLocale *)locale;
- (BOOL)isToday;
- (BOOL)isYesterday;

- (BOOL)compareToSecondsWithDate:(NSDate *)date;

@end
