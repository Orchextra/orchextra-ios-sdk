//
//  GIGDocumentValidator.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGDocumentValidator.h"


@implementation GIGDocumentValidator

- (instancetype)init
{
    return [self initWithRegexpPattern:@"^(([A-Za-z][0-9]{7}[A-Za-z0-9])|([0-9]{8}[A-Za-z]))$"];
}

@end
