//
//  ORCFormatterLog.h
//  Orchextra
//
//  Created by Judith Medina on 17/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "CocoaLumberjack.h"

@interface ORCFormatterLog : NSObject //<DDLogFormatter>
{
    int loggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}
@end
