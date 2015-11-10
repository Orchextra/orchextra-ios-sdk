//
//  ORCURLCommunicator.h
//  Orchestra
//
//  Created by Judith Medina on 25/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLAuthCommunicator.h"

@class ORCURLRequest;


@interface ORCURLCommunicator : GIGURLAuthCommunicator

- (ORCURLRequest *)GET:(NSString *)url;
- (ORCURLRequest *)POST:(NSString *)url;
- (ORCURLRequest *)DELETE:(NSString *)url;
- (ORCURLRequest *)PUT:(NSString *)url;

@end
