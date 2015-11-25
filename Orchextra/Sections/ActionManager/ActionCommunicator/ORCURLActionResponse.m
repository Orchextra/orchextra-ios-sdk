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

@implementation ORCURLActionResponse

- (instancetype)initWithData:(NSData *)data
{
    self = [super initWithData:data];
    
    if (self)
    {
        if (self.success)
        {
            if (self.jsonData)
            {
                [self parseActionResponse:self.jsonData];
            }
        }
        else
        {
            self.error = [NSError errorWithDomain:@"com.orchextra.error.actionresponse" code:2000 userInfo:nil];
        }
    }
    
    return self;
}

- (void)parseActionResponse:(NSDictionary *)json
{
    NSString *type = json[@"type"];
    
    self.action = [[ORCAction alloc] initWithType:type json:json];
}

@end
