//
//  GIGURLFormatter.h
//  giglibrary
//
//  Created by Sergio Baró on 14/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GIGURLFormatter : NSObject

- (NSString *)formatUrl:(NSString *)url withProtocol:(NSString *)protocol;

@end
