//
//  NSDate+GIGExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 16/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "NSDate+GIGExtension.h"
#import <GIGLibrary/GIGLibrary-Swift.h>


@implementation NSDate (GIGExtension)


+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format locale:(NSLocale *)locale
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    
    if (locale)
    {
        dateFormatter.locale = locale;
    }
    
    return [dateFormatter dateFromString:dateString];
}

+ (NSDate *)randomDate
{
    NSInteger day = arc4random_uniform(31) + 1;
    NSInteger month = arc4random_uniform(12) + 1;
    NSInteger year = arc4random_uniform(2013 - 2000) + 2000;
    
    NSInteger hour = arc4random_uniform(24) + 1;
    NSInteger minutes = arc4random_uniform(60) + 1;
    NSInteger seconds = arc4random_uniform(60) + 1;
    
    NSString *dateString = [NSString stringWithFormat:@"%02d/%02d/%04d %02d:%02d:%02d", (int)day, (int)month, (int)year, (int)hour, (int)minutes, (int)seconds];
	
	return [NSDate dateFromString:dateString format:@"dd/MM/yyyy HH:mm:ss" locale:[NSLocale currentLocale]];
}

+ (NSTimeInterval)timeIntervalSince1970
{
    return [NSDate timeIntervalSinceReferenceDate] + NSTimeIntervalSince1970;
}

+ (NSDate *)yesterday
{
    return [[NSDate date] dateByAddingDays:-1];
}

+ (NSDate *)afterYesterday
{
    return [[NSDate date] dateByAddingDays:-2];
}

+ (NSDate *)tomorrow
{
    return [[NSDate date] dateByAddingDays:1];
}

- (NSString *)stringWithFormat:(NSString *)dateFormat locale:(NSLocale *)locale
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = dateFormat;
    dateFormatter.AMSymbol = @"";
    dateFormatter.PMSymbol = @"";
	
    if (locale)
    {
        dateFormatter.locale = locale;
    }
    
	return [dateFormatter stringFromDate:self];
}

- (NSString *)stringWithFormat:(NSString *)dateFormat
{
    return [self stringWithFormat:dateFormat locale:nil];
}

- (BOOL)isToday
{
    return ([self compareWithoutTimeWithDate:[NSDate date]]);
}

- (BOOL)isYesterday
{
    return ([self compareWithoutTimeWithDate:[NSDate yesterday]]);
}

- (BOOL)compareToSecondsWithDate:(NSDate *)date
{
    return ([[self dateWithSeconds] isEqualToDate:[date dateWithSeconds]]);
}

- (NSInteger)numberOfDaysFromNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                                        fromDate:[NSDate date]
                                                          toDate:self
                                                         options:kNilOptions];
    
    return [components day];
}

- (NSDate *)dateByAddingDays:(NSInteger)numberOfDays
{
    return [self dateByAddingTimeInterval:60*60*24*numberOfDays];
}

#pragma mark - Private

- (BOOL)compareWithoutTimeWithDate:(NSDate *)date
{
    return ([[self dateWithoutTime] isEqualToDate:[date dateWithoutTime]]);
}

- (NSDate *)dateWithSeconds
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *selfComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond)
                                                   fromDate:self];
    
    return [calendar dateFromComponents:selfComponents];
}

- (NSDate *)dateWithoutTime
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *selfComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay)
                                                   fromDate:self];
    
    return [calendar dateFromComponents:selfComponents];
}

@end
