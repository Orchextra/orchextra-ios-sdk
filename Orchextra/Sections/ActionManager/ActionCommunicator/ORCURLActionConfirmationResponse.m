//
//  ORCURLActionConfirmationResponse.m
//  Orchextra
//
//  Created by Judith Medina on 12/1/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCURLActionConfirmationResponse.h"

@implementation ORCURLActionConfirmationResponse

- (instancetype)initWithData:(NSData *)data
{
    self = [super initWithData:data];
    
    if (self)
    {
        if (self.success)
        {
            if (self.jsonData)
            {

            }
        }
    }
    
    return self;
}

@end
