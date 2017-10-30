//
//  GIGURLFile.h
//  gignetwork
//
//  Created by Sergio Baró on 26/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GIGURLFile : NSObject

@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) NSString *parameterName;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *mimeType;

@end
