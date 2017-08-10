//
//  GIGURLRequestFactory.h
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORCGIGURLManager;
@class ORCGIGURLRequest;


@interface ORCGIGURLRequestFactory : NSObject

@property (strong, nonatomic) Class requestClass; // GIGURLRequest or subclass

- (instancetype)initWithManager:(ORCGIGURLManager *)urlManager;

- (ORCGIGURLRequest *)requestWithMethod:(NSString *)method url:(NSString *)url;

@end
