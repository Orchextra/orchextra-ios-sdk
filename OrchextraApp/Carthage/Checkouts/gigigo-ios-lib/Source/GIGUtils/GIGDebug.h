//
//  GIGDebug.h
//  giglibrary
//
//  Created by Sergio Baró on 12/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#ifndef utils_GIGDebug_h
#define utils_GIGDebug_h

#import "GIGLogManager.h"

#define GIG_OVERRIDE
#define GIG_ABSTRACT
#define GIG_CONVENIENCE

#define GIGThrowException(message) [NSException raise:NSInternalInconsistencyException format:message];
#define GIGThrowAbstractMethodException() [NSException raise:NSInternalInconsistencyException format:@"%s is an abstract method and should be overriden", __PRETTY_FUNCTION__]
#define GIGThrowInitException(selector) [NSException raise:NSInternalInconsistencyException format:@"Use %@ instead of %s", NSStringFromSelector(selector), __PRETTY_FUNCTION__]; return nil

#define GIGSuppressPerformSelectorLeakWarning(code) \
    do { \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        code; \
        _Pragma("clang diagnostic pop") \
    } while (0)

__unused static void GIGUncaughtExceptionHandler(NSException *exception)
{
	GIGLogException(exception);
}

#endif
