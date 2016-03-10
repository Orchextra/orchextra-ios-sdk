//
//  ORCTrigger.m
//  Orchestra
//
//  Created by Judith Medina on 7/5/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCAction.h"
#import "ORCActionInterface.h"
#import "ORCActionScanner.h"
#import "ORCActionWebView.h"
#import "ORCActionBrowser.h"
#import "ORCConstants.h"
#import "ORCActionCommunicator.h"
#import "ORCGIGJSON.h"

NSString * const ORC_LAUNCHED_BY_ID = @"launchedById";
NSString * const ORC_TITLE = @"title";
NSString * const ORC_BODY = @"body";
NSString * const ORC_URL = @"url";
NSString * const ORC_TYPE = @"type";
NSString * const ORC_TRACK_ID = @"trackId";

NSString * const ORC_SCHEDULE = @"schedule";
NSString * const ORC_SECONDS = @"seconds";
NSString * const ORC_CANCELABLE = @"cancelable";


@interface ORCAction ()

@property (strong, nonatomic) NSDictionary *json;

@end

@implementation ORCAction

#pragma mark - INIT

- (instancetype)initWithJSON:(NSDictionary *)json
{
    return [self initWithType:[json stringForKey:ORC_TYPE] json:json];
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
        if ([ORCActionOpenScannerID isEqualToString:type])
        {
            self = [[ORCActionScanner alloc] init];
            self.actionWithUserInteraction = YES;
        }
        else if ([ORCActionOpenWebviewID isEqualToString:type])
        {
            self = [[ORCActionWebView alloc] init];
            self.actionWithUserInteraction = YES;
        }
        else if ([ORCActionOpenBrowserID isEqualToString:type])
        {
            self = [[ORCActionBrowser alloc] init];
            self.actionWithUserInteraction = YES;
        }
        else if ([ORCActionVuforiaID isEqualToString:type])
        {
            if (NSClassFromString(@"ORCActionVuforia"))
            {
                self = [[NSClassFromString(@"ORCActionVuforia") alloc] init];
                self.actionWithUserInteraction = YES;
            }
        }
        else
        {
            self = [[ORCAction alloc] init];
            self.actionWithUserInteraction = NO;
        }
        
        _type = type;
        
        if (json)
        {
            _trackId = [json stringForKey:ORC_TRACK_ID];
            
            NSString *url = [json stringForKey:ORC_URL];
            _urlString = (url) ? url : @"";
            
            NSDictionary *notification = [json dictionaryForKey:@"notification"];
            
            if (![notification isKindOfClass:[NSNull class]])
            {
                _titleNotification = [notification stringForKey:ORC_TITLE];
                _bodyNotification = [notification stringForKey:ORC_BODY];
            }
            
            _launchedByTriggerCode = [json stringForKey:ORC_LAUNCHED_BY_ID];
            
            NSDictionary *schedule = [json dictionaryForKey:ORC_SCHEDULE];
            _scheduleTime = [schedule integerForKey:ORC_SECONDS];
            _cancelable = [schedule boolForKey:ORC_CANCELABLE];
        }
    }
    
    return self;
}

- (void)executeActionWithActionInterface:(id<ORCActionInterface>)actionInterface
{
    if (self.urlString.length > 0)
    {
        [actionInterface presentActionWithCustomScheme:self.urlString];
    }
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *actionDic = [[NSMutableDictionary alloc] init];
    
    if (self.trackId)
    {
        [actionDic addEntriesFromDictionary:@{ORC_TRACK_ID : self.trackId}];
    }
    
    if (self.launchedByTriggerCode)
    {
        [actionDic addEntriesFromDictionary:@{ORC_LAUNCHED_BY_ID : self.launchedByTriggerCode}];
    }
    
    if(self.titleNotification)
    {
        [actionDic addEntriesFromDictionary:@{ORC_TITLE : self.titleNotification}];
    }
    
    if(self.bodyNotification)
    {
        [actionDic addEntriesFromDictionary:@{ORC_BODY : self.bodyNotification}];
    }
    
    if(self.type)
    {
        [actionDic addEntriesFromDictionary:@{ORC_TYPE : self.type}];
    }
    
    if(![self.urlString isKindOfClass:[NSNull class]])
    {
        [actionDic addEntriesFromDictionary:@{ORC_URL : self.urlString}];
    }
    
    if (self.scheduleTime)
    {
        [actionDic addEntriesFromDictionary:@{ORC_SECONDS : @(self.scheduleTime)}];
    }
    
    if (self.cancelable)
    {
        [actionDic addEntriesFromDictionary:@{ORC_CANCELABLE : @(self.cancelable)}];
    }
    
    return actionDic;
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"Action id: %@, type: %@ \n title: %@, body: %@, url: %@",
                             self.trackId, self.type, self.titleNotification, self.bodyNotification, self.urlString];
    
    return description;
}



@end
