//
//  ORCLogWrapper.m
//  Orchextra
//
//  Created by Judith Medina on 17/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCLog.h"
#import "ORCFormatterLog.h"

//static DDLogLevel ddLogLevel = DDLogLevelDebug;

@interface ORCLog ()
    @property (assign, nonatomic) ORCLogLevel internalLog;
@end


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
    }
    
    return self;
}

- (void)logLevel:(ORCLogLevel)level
{
    self.internalLog = level;
}

- (void)logError:(NSString *)format
{
    if (self.internalLog > ORCLogLevelOff) {
        NSLog(@"ERROR: %@",format);
    }
}

- (void)logWarning:(NSString *)format
{
    if (self.internalLog > ORCLogLevelError) {
        NSLog(@"WARNING: %@",format);
    }
}

- (void)logDebug:(NSString *)format
{
    if (self.internalLog > ORCLogLevelWarning) {
        NSLog(@"DEBUG: %@",format);
    }
}

- (void)logVerbose:(NSString *)format
{
    if (self.internalLog > ORCLogLevelWarning) {
        NSLog(@"VERBOSE: %@",format);
    }
}

- (bool)isLogError
{
    return self.internalLog > ORCLogLevelOff
}

- (bool)isLogWarning
{
    return self.internalLog > ORCLogLevelError
}

- (bool)isLogDebug
{
    return self.internalLog > ORCLogLevelWarning
}

- (bool)isLogVerbose
{
    return self.internalLog > ORCLogLevelWarning
}

@end
