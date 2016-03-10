//
//  OrchestraCommunicator.m
//  Orchestra
//
//  Created by Judith Medina on 28/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <AdSupport/AdSupport.h>
#import "ORCGIGURLManager.h"

#import "ORCAppConfigCommunicator.h"
#import "ORCFormatterParameters.h"
#import "ORCURLRequest.h"
#import "ORCSettingsPersister.h"
#import "ORCURLProvider.h"

NSString * const CONFIGURATION_ENDPOINT = @"configuration";

@implementation ORCAppConfigCommunicator


#pragma mark - PUBLIC

- (void)loadConfiguration:(NSDictionary *)configuration
               completion:(CompletionOrchestraConfigResponse)completion
{    
    [ORCLog logVerbose:@" - Configuration Body: %@", [self printJsonFormat:configuration]];

    [self useFixtures:ORCUseFixtures];
    self.logLevel = GIGLogLevelBasic;    

    ORCURLRequest *request = [[ORCURLRequest alloc] initWithMethod:@"POST" url:[ORCURLProvider endPointConfiguration]];

    request.json = configuration;
    request.responseClass = [ORCAppConfigResponse class];
    request.requestTag = CONFIGURATION_ENDPOINT;
    
    [self send:request completion:completion];
}

#pragma mark - PRIVATE

- (void)useFixtures:(BOOL)useFixtures
{
    [[ORCGIGURLManager sharedManager] setUseFixture:useFixtures];
}

- (NSString *)printJsonFormat:(NSDictionary *)json
{
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}


@end
