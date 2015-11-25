//
//  ORCGIGLogManager.m
//  giglibrary
//
//  Created by Sergio Baró on 17/03/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import "ORCGIGLogManager.h"

#import <NSBundle+ORCGIGExtension.h>


@implementation ORCGIGLogManager

+ (instancetype)shared
{
	static ORCGIGLogManager *instance = nil;
	
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		instance = [[ORCGIGLogManager alloc] init];
    });
	
	return instance;
}


- (instancetype)init
{
    self = [super init];
    if (self)
    {
		self.appName = [NSBundle productName];
#ifdef DEBUG
		self.logEnabled = YES;
#else
        self.logEnabled = NO;
#endif
    }
    return self;
}

#pragma mark - Public

+ (void)logMessage:(NSString *)message
{
    if ([ORCGIGLogManager shared].logEnabled)
    {
        [ORCGIGLogManager logString:message withHeader:YES];
    }
}

+ (void)log:(NSString *)format, ...
{
	va_list ap;
	va_start(ap, format);
	NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
	
	if ([ORCGIGLogManager shared].logEnabled)
	{
		[ORCGIGLogManager logString:output withHeader:YES];
	}
}

+ (void)info:(NSString *)format, ...
{
	va_list ap;
	va_start(ap, format);
	NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
    
	if ([ORCGIGLogManager shared].logEnabled)
	{
		NSString *caller = [ORCGIGLogManager caller];
		NSString *log = [NSString stringWithFormat:@"ℹ️ℹ️ℹ️ INFO: %@\nℹ️ℹ️ℹ️ ⤷ FROM CALLER: %@", output, caller];
		
		[ORCGIGLogManager logString:log withHeader:NO];
	}
}

+ (void)warn:(NSString *)format, ...
{
	va_list ap;
	va_start(ap, format);
	NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
	
	if ([ORCGIGLogManager shared].logEnabled)
	{
		NSString *caller = [ORCGIGLogManager caller];
		NSString *log = [NSString stringWithFormat:@"🚸🚸🚸 WARNING: %@\n🚸🚸🚸 ⤷ FROM CALLER: %@\n", output, caller];
		
        [ORCGIGLogManager logString:@"" withHeader:NO];
		[ORCGIGLogManager logString:log withHeader:NO];
        [ORCGIGLogManager logString:@"" withHeader:NO];
	}
}

+ (void)error:(NSString *)format, ...
{
	va_list ap;
	va_start(ap, format);
	NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
	
	if ([ORCGIGLogManager shared].logEnabled)
	{
		NSString *caller = [ORCGIGLogManager caller];
		NSString *log = [NSString stringWithFormat:@"❌❌❌ ERROR: %@\n❌❌❌ ⤷ FROM CALLER: %@\n", output, caller];
		
        [ORCGIGLogManager logString:@"" withHeader:NO];
		[ORCGIGLogManager logString:log withHeader:NO];
        [ORCGIGLogManager logString:@"" withHeader:NO];
	}
}

+ (void)logError:(NSError *)error
{
	if ([ORCGIGLogManager shared].logEnabled)
	{
		NSString *caller = [ORCGIGLogManager caller];
		NSString *log = [NSString stringWithFormat:@"❌❌❌ ERROR: %@\n❌❌❌ ⤷ FROM CALLER: %@\n❌❌❌ ⤷ USER INFO:\n%@", error.localizedDescription, caller, error.userInfo];
        
        [ORCGIGLogManager logString:@"" withHeader:NO];
		[ORCGIGLogManager logString:log withHeader:NO];
        [ORCGIGLogManager logString:@"" withHeader:NO];
	}
}

+ (void)logException:(NSException *)exception
{
	if ([ORCGIGLogManager shared].logEnabled)
	{
		NSString *caller = [ORCGIGLogManager caller];
		NSString *log = [NSString stringWithFormat:@"‼️‼️‼️ EXCEPTION: %@\n‼️‼️‼️ ⤷ FROM CALLER: %@\n‼️‼️‼️ ⤷ STACK:\n%@", exception.name, caller, [exception callStackSymbols]];
        
        [ORCGIGLogManager logString:@"" withHeader:NO];
		[ORCGIGLogManager logString:log withHeader:NO];
        [ORCGIGLogManager logString:@"" withHeader:NO];
	}
}

#pragma mark - Private

+ (NSString *)caller
{
	NSArray *syms = [NSThread  callStackSymbols];
	NSString *aux = @"";
	NSString *caller = [syms objectAtIndex:2];
	
	if (([caller rangeOfString:@"["].location != NSNotFound) && ([caller rangeOfString:@"]"].location != NSNotFound))
	{
		NSInteger index = [caller rangeOfString:@"["].location;
		if (index > 0)
		{
			aux = [caller substringToIndex:index];
			caller = [caller stringByReplacingOccurrencesOfString:aux withString:@""];
		}
		
		index = [caller rangeOfString:@"]"].location;
		if (index > 0)
		{
			aux = [caller substringFromIndex:index];
			caller = [caller stringByReplacingOccurrencesOfString:aux withString:@"]"];
		}
	}
	
	return caller;
}

+ (NSString *)currentTime
{
	NSDateFormatter *formater = [[NSDateFormatter alloc] init];
	formater.dateFormat = @"<HH:mm:ss:SSS>";
	
	NSDate *now = [NSDate date];
	return [formater stringFromDate:now];
}

+ (void)logString:(NSString *)log withHeader:(BOOL)withHeader
{
	BOOL isDebug = NO;

#if DEBUG
	isDebug = YES;
#endif
	
	NSString *finalOutput;
	
	if (withHeader && isDebug)
	{
		finalOutput = [NSString stringWithFormat:@"* %@ %@ -> %@\n", [ORCGIGLogManager currentTime], [ORCGIGLogManager shared].appName, log];
	}
	else
	{
		finalOutput = [NSString stringWithFormat:@"%@\n", log];
	}
	
	if (isDebug)
	{
		[[NSFileHandle fileHandleWithStandardOutput] writeData: [finalOutput dataUsingEncoding: NSUTF8StringEncoding]];
	}
	else
	{
		NSLog(@"%@", finalOutput);
	}
}

@end
