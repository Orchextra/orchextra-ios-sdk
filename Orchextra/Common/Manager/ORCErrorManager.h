//
//  ORCErrorManager.h
//  Orchextra
//
//  Created by Judith Medina on 18/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GIGLibrary/GIGURLJSONResponse.h>

@interface ORCErrorManager : NSObject

+ (NSString *)errorMessageWithError:(NSError *)error;
+ (NSError *)errorWithResponse:(GIGURLJSONResponse *)response;
+ (NSError *)errorWithErrorCode:(NSInteger)errorCode;

@end
