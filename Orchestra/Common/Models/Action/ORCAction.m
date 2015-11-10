//
//  ORCTrigger.m
//  Orchestra
//
//  Created by Judith Medina on 7/5/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCAction.h"
#import "ORCActionInterface.h"
#import "ORCActionVuforia.h"
#import "ORCActionScanner.h"
#import "ORCActionWebView.h"
#import "ORCActionBrowser.h"

@interface ORCAction ()

@property (strong, nonatomic) NSDictionary *json;

@end

@implementation ORCAction

#pragma mark - INIT

- (instancetype)initWithJSON:(NSDictionary *)json
{
    return [self initWithType:json[@"type"] json:json];
}

- (instancetype)initWithType:(NSString *)type
{
    return [self initWithType:type json:nil];
}


- (instancetype)initWithType:(NSString *)type json:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        if ([ORCTypeBarcode isEqualToString:type]   ||
            [ORCTypeQR isEqualToString:type]        ||
            [ORCTypeScan isEqualToString:type])
        {
            self = [[ORCActionScanner alloc] init];
        }
        else if ([ORCTypeOpenWebview isEqualToString:type])
        {
            self = [[ORCActionWebView alloc] init];
        }
        else if ([ORCTypeOpenBrowser isEqualToString:type])
        {
            self = [[ORCActionBrowser alloc] init];
        }
        else if ([ORCTypeVuforia isEqualToString:type])
        {
            self = [[ORCActionVuforia alloc] init];
        }
        else
        {
            self = [[ORCAction alloc] init];
        }
        
        _type = type;
        
        if (json)
        {
            NSString *url = json[@"url"];
            
            _urlString = (url) ? url : @"";
            
            NSDictionary *notification = json[@"notification"];
            
            if (![notification isKindOfClass:[NSNull class]])
            {
                _titleNotification = notification[@"title"];
                _messageNotification = notification[@"body"];
            }
        }
    }
    
    return self;
}

- (void)executeActionWithActionInterface:(id<ORCActionInterface>)actionInterface
{
    if (![self.urlString isKindOfClass:[NSNull class]])
    {
        [actionInterface presentActionWithCustomScheme:self.urlString];
    }
}



@end
