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
                 sections:(NSArray *)sections
               completion:(CompletionOrchestraConfigResponse)completion
{
    [[ORCLog sharedInstance] logVerbose:[NSString stringWithFormat: @" - Configuration Body: %@", [self printJsonFormat:configuration]]];

    
    [self useFixtures:ORCUseFixtures];
    self.logLevel = GIGLogLevelBasic;
    
    NSMutableString *endPointConfiguration = [[NSMutableString alloc] initWithString:[ORCURLProvider endPointConfiguration]];
    if (sections.count > 0)
    {
        [endPointConfiguration appendString:@"?sections="];
        for (NSUInteger i = 0; i < sections.count; i++)
        {
            NSString *section = [sections objectAtIndex:i];
            NSUInteger nextElement = i + 1;
            [endPointConfiguration appendString:section];
            
            if (nextElement < sections.count)
            {
                [endPointConfiguration appendString:@","];
            }
        }
    }
    
    ORCURLRequest *request = [[ORCURLRequest alloc] initWithMethod:@"POST" url:endPointConfiguration];
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
