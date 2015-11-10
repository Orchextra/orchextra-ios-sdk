//
//  GIGURLRequestFactory.m
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLRequestFactory.h"

#import "ORCGIGURLRequest.h"
#import "ORCGIGURLManager.h"


@interface ORCGIGURLRequestFactory ()

@property (strong, nonatomic) ORCGIGURLManager *manager;

@end


@implementation ORCGIGURLRequestFactory

- (instancetype)init
{
    ORCGIGURLManager *manager = [ORCGIGURLManager sharedManager];
    
    return [self initWithManager:manager];
}

- (instancetype)initWithManager:(ORCGIGURLManager *)manager
{
    self = [super init];
    if (self)
    {
        _requestClass = [ORCGIGURLRequest class];
        _manager = manager;
    }
    return self;
}

#pragma mark - PUBLIC

- (ORCGIGURLRequest *)requestWithMethod:(NSString *)method url:(NSString *)url
{
    return [[self.requestClass alloc] initWithMethod:method url:url manager:self.manager];
}

@end
