//
//  ORCErrorManager.m
//  Orchextra
//
//  Created by Judith Medina on 18/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCErrorManager.h"
#import <GIGLibrary/GIGJSON.h>

// Variables
NSString * const ORCErrorKey = @"error";
NSString * const ORCErrorCodeKey = @"code";
NSString * const ORCErrorMessageKey = @"message";

NSString * const ORCErrorDomain = @"com.orchextra.sdk";

// Messages Error
NSString * const kORCUnexpectedError = @"Unexpected error.";
NSString * const kORCErrorCredentials = @"Incorrect ApiKey or ApiSecret, check them before continuing.";
NSString * const kORCErrorAccessTokenInvalid = @"Access token expired or invalid.";
NSString * const kErrorActionNotFoundMessage = @"Action not found.";


@implementation ORCErrorManager

+ (NSString *)errorMessageWithError:(NSError *)error
{
    if (error.localizedDescription)
    {
        return error.localizedDescription;
    }
    
    return kORCUnexpectedError;
}

+ (NSError *)errorWithResponse:(ORCGIGURLJSONResponse *)response
{
    NSError *error = nil;
    NSDictionary *errorjson = [response.data toJSON];
    
    if (errorjson != nil &&
        [errorjson isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *errorDic = [errorjson dictionaryForKey:@"error"];
        NSString *message = nil;
        NSInteger code = 0;
        
        if (errorDic != nil &&
            ([errorDic isKindOfClass:[NSDictionary class]]))
        {
            code = [errorDic integerForKey:ORCErrorCodeKey];
        }

        switch (code) {
            case 401:
                message = kORCErrorAccessTokenInvalid;
                break;
                
            case 403:
                message = kORCErrorCredentials;
                break;
                
            case 2001:
                message = kErrorActionNotFoundMessage;
                break;
                
            default:
                message = kORCUnexpectedError;
                break;
        }

        error = [NSError errorWithDomain:ORCErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey : message}];
    }
    else
    {
        error = [NSError errorWithDomain:ORCErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : kORCUnexpectedError}];
    }
    
    return error;
}

+ (NSError *)errorWithErrorCode:(NSInteger)errorCode
{
    NSError *error = nil;
    NSString *message = nil;
    
    switch (errorCode) {
            
        case 2001:
            message = kErrorActionNotFoundMessage;
            break;
            
        default:
            message = kErrorActionNotFoundMessage;
            break;
    }

    error = [NSError errorWithDomain:ORCErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey : message}];

    return error;
}

@end
