//
//  GIGURLJSONResponse.m
//  GIGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "ORCGIGURLJSONResponse.h"

#import "ORCGIGJSON.h"
#import "ORCErrorNetworkHandler.h"


@implementation ORCGIGURLJSONResponse

- (instancetype)initWithData:(NSData *)data
{
    self = [super initWithData:data];
    
    if (self)
    {
        if (self.success)
        {
            NSError *error = nil;
            self.json = [data toJSONError:&error];
            self.jsonData = self.json[@"data"];
            self.error = nil;
            
            if (self.jsonData == nil)
            {
                self.success = NO;
                self.jsonData = nil;
                if (self.json[@"error"])
                {
                    NSDictionary *errorJSON = self.json[@"error"];
                    self.error = [NSError errorWithDomain:ORCOrchextraDomain
                                                     code:[errorJSON[@"code"] integerValue]
                                                 userInfo:[NSDictionary dictionaryWithObject:errorJSON[@"message"]
                                                                                      forKey:NSLocalizedDescriptionKey]];
                }

            }

        }
        else
        {
            NSDictionary *errorJSON = self.json[@"error"];
            self.error = [NSError errorWithDomain:@"com.orchextra"
                                             code:[errorJSON[@"code"] integerValue]
                                         userInfo:[NSDictionary dictionaryWithObject:errorJSON[@"message"]
                                                                              forKey:NSLocalizedDescriptionKey]];
        }
    }
    return self;
}

- (instancetype)initWithJSON:(id)json
{
    NSData *data = [json toData];
    
    return [self initWithData:data];
}

@end
