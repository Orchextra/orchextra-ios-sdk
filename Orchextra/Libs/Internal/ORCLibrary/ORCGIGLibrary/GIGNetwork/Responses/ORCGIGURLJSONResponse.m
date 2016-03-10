//
//  GIGURLJSONResponse.m
//  GIGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "ORCGIGURLJSONResponse.h"
#import "ORCErrorManager.h"
#import "ORCGIGJSON.h"


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
                    self.error = [ORCErrorManager errorWithResponse:self];
                }
            }
        }
        else
        {
            self.error = [ORCErrorManager errorWithResponse:self];
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
