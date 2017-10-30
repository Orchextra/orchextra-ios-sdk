//
//  GIGLogManager.m
//  giglibrary
//
//  Created by Sergio Baró on 17/03/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import "GIGLogManager.h"

#import "NSBundle+GIGExtension.h"


@implementation GIGLogManager

+ (instancetype)shared
{
	static GIGLogManager *instance = nil;
	
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		instance = [[GIGLogManager alloc] init];
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
    if ([GIGLogManager shared].logEnabled)
    {
        [GIGLogManager logString:message withHeader:YES];
    }
}

+ (void)log:(NSString *)format, ...
{
	va_list ap;
	va_start(ap, format);
	NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
	
	if ([GIGLogManager shared].logEnabled)
	{
		[GIGLogManager logString:output withHeader:YES];
	}
}

+ (void)info:(NSString *)format, ...
{
	va_list ap;
	va_start(ap, format);
	NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
    
	if ([GIGLogManager shared].logEnabled)
	{
		NSString *caller = [GIGLogManager caller];
		NSString *log = [NSString stringWithFormat:@"ℹ️ℹ️ℹ️ INFO: %@\nℹ️ℹ️ℹ️ ⤷ FROM CALLER: %@", output, caller];
		
		[GIGLogManager logString:log withHeader:NO];
	}
}

+ (void)warn:(NSString *)format, ...
{
	va_list ap;
	va_start(ap, format);
	NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
	
	if ([GIGLogManager shared].logEnabled)
	{
		NSString *caller = [GIGLogManager caller];
		NSString *log = [NSString stringWithFormat:@"🚸🚸🚸 WARNING: %@\n🚸🚸🚸 ⤷ FROM CALLER: %@\n", output, caller];
		
        [GIGLogManager logString:@"" withHeader:NO];
		[GIGLogManager logString:log withHeader:NO];
        [GIGLogManager logString:@"" withHeader:NO];
	}
}

+ (void)error:(NSString *)format, ...
{
	va_list ap;
	va_start(ap, format);
	NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
	
	if ([GIGLogManager shared].logEnabled)
	{
		NSString *caller = [GIGLogManager caller];
		NSString *log = [NSString stringWithFormat:@"❌❌❌ ERROR: %@\n❌❌❌ ⤷ FROM CALLER: %@\n", output, caller];
		
        [GIGLogManager logString:@"" withHeader:NO];
		[GIGLogManager logString:log withHeader:NO];
        [GIGLogManager logString:@"" withHeader:NO];
	}
}

+ (void)logError:(NSError *)error
{
	if ([GIGLogManager shared].logEnabled)
	{
		NSString *caller = [GIGLogManager caller];
		NSString *log = [NSString stringWithFormat:@"❌❌❌ ERROR: %@\n❌❌❌ ⤷ FROM CALLER: %@\n❌❌❌ ⤷ USER INFO:\n%@", error.localizedDescription, caller, error.userInfo];
        
        [GIGLogManager logString:@"" withHeader:NO];
		[GIGLogManager logString:log withHeader:NO];
        [GIGLogManager logString:@"" withHeader:NO];
	}
}

+ (void)logException:(NSException *)exception
{
	if ([GIGLogManager shared].logEnabled)
	{
		NSString *caller = [GIGLogManager caller];
		NSString *log = [NSString stringWithFormat:@"‼️‼️‼️ EXCEPTION: %@\n‼️‼️‼️ ⤷ FROM CALLER: %@\n‼️‼️‼️ ⤷ STACK:\n%@", exception.name, caller, [exception callStackSymbols]];
        
        [GIGLogManager logString:@"" withHeader:NO];
		[GIGLogManager logString:log withHeader:NO];
        [GIGLogManager logString:@"" withHeader:NO];
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
		finalOutput = [NSString stringWithFormat:@"* %@ %@ -> %@\n", [GIGLogManager currentTime], [GIGLogManager shared].appName, log];
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
