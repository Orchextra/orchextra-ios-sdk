//
//  ORCURLCommunicator.m
//  Orchestra
//
//  Created by Judith Medina on 25/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCURLCommunicator.h"

#import "ORCURLRequest.h"

@interface ORCGIGURLCommunicator ()

@property (strong, nonatomic) ORCGIGURLRequest *lastRequest;

@end

@implementation ORCURLCommunicator

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.logLevel = GIGLogLevelBasic;
    }
    
    return self;
}

- (ORCURLRequest *)GET:(NSString *)url
{
    self.lastRequest = [[ORCURLRequest alloc] initWithMethod:@"GET" url:url];
    
    return (ORCURLRequest *)self.lastRequest;
}

- (ORCURLRequest *)POST:(NSString *)url
{
    self.lastRequest = [[ORCURLRequest alloc] initWithMethod:@"POST" url:url];
    
    return (ORCURLRequest *)self.lastRequest;
}

- (ORCURLRequest *)DELETE:(NSString *)url
{
    self.lastRequest = [[ORCURLRequest alloc] initWithMethod:@"DELETE" url:url];
    
    return (ORCURLRequest *)self.lastRequest;
}

- (ORCGIGURLRequest *)PUT:(NSString *)url
{
    self.lastRequest = [[ORCURLRequest alloc] initWithMethod:@"PUT" url:url];
    
    return (ORCURLRequest *)self.lastRequest;
}

@end
