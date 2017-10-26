//
//  ORCLogWrapper.m
//  Orchextra
//
//  Created by Judith Medina on 17/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCLog.h"
#import "CocoaLumberjack.h"
#import "ORCFormatterLog.h"

static DDLogLevel ddLogLevel = DDLogLevelDebug;

@implementation ORCLog

+ (instancetype)sharedInstance
{
    static ORCLog *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ORCLog alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [DDTTYLogger sharedInstance].logFormatter = [[ORCFormatterLog alloc] init];
        ddLogLevel = DDLogLevelError;
    }
    
    return self;
}

+ (void)logLevel:(ORCLogLevel)level
{
    [ORCLog sharedInstance];
    
    switch (level) {
        case ORCLogLevelOff:
            ddLogLevel = DDLogLevelOff;
            break;
            
        case ORCLogLevelError:
            ddLogLevel = DDLogLevelError;
            break;
            
        case ORCLogLevelWarning:
            ddLogLevel = DDLogLevelWarning;
            break;
            
        case ORCLogLevelDebug:
            ddLogLevel = DDLogLevelDebug;
            break;
        case ORCLogLevelAll:
            ddLogLevel = DDLogLevelAll;
            break;
        default:
            break;
    }
}

+ (void)addLogsToFile
{
    [ORCLog sharedInstance];

    // Initialize File Logger
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    
    // Configure File Logger
    [fileLogger setMaximumFileSize:(1024 * 1024)];
    [fileLogger setRollingFrequency:(60*60*24)];
    [[fileLogger logFileManager] setMaximumNumberOfLogFiles:7];
    [DDLog addLogger:fileLogger];
}

+ (void)logError:(NSString *)format, ...
{
    [ORCLog sharedInstance];
    
    if (format)
    {
        va_list ap;
        va_start(ap, format);
        NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
        va_end(ap);
        
        DDLogVerbose(@"ERROR %@", output);
    }
}

+ (void)logWarning:(NSString *)format, ...
{
    [ORCLog sharedInstance];
    
    if (format)
    {
        va_list ap;
        va_start(ap, format);
        NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
        va_end(ap);
        DDLogVerbose(@"WARN: %@", output);
    }
}

+ (void)logDebug:(NSString *)format, ...
{
    [ORCLog sharedInstance];
    
    if (format)
    {
        va_list ap;
        va_start(ap, format);
        NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
        va_end(ap);
        
        DDLogVerbose(@"DEBUG: %@", output);
    }
}

+ (void)logVerbose:(NSString *)format, ...
{
    [ORCLog sharedInstance];
    
    if (format)
    {
        va_list ap;
        va_start(ap, format);
        NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
        va_end(ap);
        
        DDLogVerbose(@"VERBOSE: %@", output);
    }
}


@end
