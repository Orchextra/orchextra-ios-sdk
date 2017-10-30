//
//  GIGURLParametersFormatter.h
//  gignetwork
//
//  Created by Sergio Baró on 25/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GIGURLParametersFormatter : NSObject

@property (assign, nonatomic) NSStringEncoding stringEncoding;
@property (assign, nonatomic) NSJSONWritingOptions jsonWritingOptions;

- (NSString *)generateBoundary;
- (NSURL *)URLWithParameters:(NSDictionary *)parameters baseUrl:(NSString *)url;
- (NSString *)queryStringWithParameters:(NSDictionary *)parameters;
- (NSData *)bodyWithParameters:(NSDictionary *)parameters;
- (NSData *)multipartBodyWithParameters:(NSDictionary *)parameters files:(NSArray *)files boundary:(NSString *)boundary;
- (NSData *)jsonBodyWithParameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error;

@end
