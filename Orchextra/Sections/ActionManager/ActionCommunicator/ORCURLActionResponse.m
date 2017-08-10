

//
//  ORCURLActionResponse.m
//  Orchestra
//
//  Created by Judith Medina on 24/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCURLActionResponse.h"
#import "ORCActionScanner.h"
#import "ORCActionWebView.h"
#import "ORCActionBrowser.h"
#import "ORCActionVuforia.h"
#import "ORCErrorManager.h"

#import <GIGLibrary/GIGJSON.h>

@implementation ORCURLActionResponse

- (instancetype)initWithData:(NSData *)data
{
    self = [super initWithData:data];
    
    if (self)
    {
        if (self.success)
        {
            if (self.json)
            {
                [self parseActionResponse:self.json];
            }
        }
        else
        {
            self.error = [ORCErrorManager errorWithErrorCode:2001];
        }
    }
    
    return self;
}

- (void)parseActionResponse:(NSDictionary *)json
{
    NSString *type = [json stringForKey:@"type"];
    self.action = [[ORCAction alloc] initWithType:type json:json];
}

@end
