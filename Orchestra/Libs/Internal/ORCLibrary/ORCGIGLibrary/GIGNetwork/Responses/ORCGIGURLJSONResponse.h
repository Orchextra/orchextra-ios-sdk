//
//  GIGURLJSONResponse.h
//  GIGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "ORCGIGURLResponse.h"


@interface ORCGIGURLJSONResponse : ORCGIGURLResponse

@property (strong, nonatomic) id json;
@property (strong, nonatomic) id jsonData;

- (instancetype)initWithJSON:(id)json;

@end
