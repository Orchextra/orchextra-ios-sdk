//
//  ORCLogWrapper.h
//  Orchextra
//
//  Created by Judith Medina on 17/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  Log levels are used to filter out logs. Used together with flags.
 */
typedef NS_ENUM(NSUInteger, ORCLogLevel){
    /**
     *  No logs
     */
    ORCLogLevelOff       = 0,
    
    /**
     *  Error logs only
     */
    ORCLogLevelError     = 1,
    
    /**
     *  Error and warning logs
     */
    ORCLogLevelWarning   = 2,
    
    /**
     *  Debug logs "basic informacion"
     */
    ORCLogLevelDebug     = 3,

    /**
     *  All logs (1...11111)
     */
    ORCLogLevelAll       = NSUIntegerMax
};


@interface ORCLog : NSObject

// SET UP

+ (void)logLevel:(ORCLogLevel)level;
+ (void)addLogsToFile;

// LOG LEVELS

+ (void)logError:(NSString *)format, ...;
+ (void)logWarning:(NSString *)format, ...;
+ (void)logDebug:(NSString *)format, ...;
+ (void)logVerbose:(NSString *)format, ...;


@end
