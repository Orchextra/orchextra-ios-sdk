//
//  GIGURLParametersFormatter.m
//  gignetwork
//
//  Created by Sergio Baró on 25/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLParametersFormatter.h"

#import "GIGURLFile.h"


@implementation GIGURLParametersFormatter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _stringEncoding = NSUTF8StringEncoding;
        _jsonWritingOptions = 0;
    }
    return self;
}

#pragma mark - PUBLIC

- (NSString *)generateBoundary
{
    return [NSString stringWithFormat:@"---------------------------%08X%08X%08X", arc4random(), arc4random(), arc4random()];
}

- (NSURL *)URLWithParameters:(NSDictionary *)parameters baseUrl:(NSString *)url
{
    NSString *finalUrl = url;
    
    if (parameters.count > 0)
    {
        NSString *queryString = [self queryStringWithParameters:parameters];
        if ([url rangeOfString:@"?" options:kNilOptions].location != NSNotFound)
        {
            finalUrl = [NSString stringWithFormat:@"%@&%@", url, queryString];
        }
        else
        {
            finalUrl = [NSString stringWithFormat:@"%@?%@", url, queryString];
        }
    }
    
    return [NSURL URLWithString:finalUrl];
}

- (NSString *)queryStringWithParameters:(NSDictionary *)parameters
{
    NSMutableArray *components = [[NSMutableArray alloc] init];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL __unused *stop) {
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:self.stringEncoding];
        if (key.length > 0)
        {
            NSString *encodedValue = [[self parameterValueToString:value] stringByAddingPercentEscapesUsingEncoding:self.stringEncoding];
            NSString *component = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
            [components addObject:component];
        }
    }];
    
    return [components componentsJoinedByString:@"&"];
}

- (NSData *)bodyWithParameters:(NSDictionary *)parameters
{
    if (parameters.count == 0) return nil;
    
    NSString *queryString = [self queryStringWithParameters:parameters];
    return [queryString dataUsingEncoding:self.stringEncoding];
}

- (NSData *)multipartBodyWithParameters:(NSDictionary *)parameters files:(NSArray *)files boundary:(NSString *)boundary
{
    NSMutableData *body = [NSMutableData data];
    
    [files enumerateObjectsUsingBlock:^(GIGURLFile *file, NSUInteger idx, BOOL __unused *stop) {
        [body appendData:[self dataForFile:file boundary:boundary]];
    }];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL __unused *stop) {
        [body appendData:[self dataForParameter:key value:value boundary:boundary]];
    }];
    
    [body appendData:[self endBoundaryLine:boundary]];
    
    return [body copy];
}

- (NSData *)jsonBodyWithParameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error
{
    if (parameters.count == 0) return nil;
    
    return [NSJSONSerialization dataWithJSONObject:parameters options:self.jsonWritingOptions error:error];
}

#pragma mark - PRIVATE

- (NSData *)endBoundaryLine:(NSString *)boundary
{
    return [[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:self.stringEncoding];
}

- (NSData *)boundaryLine:(NSString *)boundary
{
    return [[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:self.stringEncoding];
}

#pragma mark - PRIVATE (Files)

- (NSData *)dataForFile:(GIGURLFile *)file boundary:(NSString *)boundary
{
    NSMutableData *data = [[NSMutableData alloc] init];
    
    [data appendData:[self boundaryLine:boundary]];
    
    [data appendData:[self contentDispositionForFile:file]];
    [data appendData:[self contentTypeForFile:file]];
    
    [data appendData:file.data];
    
    return data;
}

- (NSData *)contentDispositionForFile:(GIGURLFile *)file
{
    NSString *result = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", file.parameterName, file.fileName];
    
    return [result dataUsingEncoding:self.stringEncoding];
}

- (NSData *)contentTypeForFile:(GIGURLFile *)file
{
    return [[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", file.mimeType] dataUsingEncoding:self.stringEncoding];
}

#pragma mark - PRIVATE (Parameters)

- (NSData *)dataForParameter:(NSString *)name value:(id)value boundary:(NSString *)boundary
{
    NSMutableData *data = [NSMutableData data];
    
    [data appendData:[self boundaryLine:boundary]];
    [data appendData:[self contentDispositionForParameter:name]];
    [data appendData:[[self parameterValueToString:value] dataUsingEncoding:self.stringEncoding]];
    
    return data;
}

- (NSData *)contentDispositionForParameter:(NSString *)parameter
{
    return [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameter] dataUsingEncoding:self.stringEncoding];
}

- (NSString *)parameterValueToString:(id)value
{
    if ([value isKindOfClass:[NSString class]])
    {
        return value;
    }
    else if ([value isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%@", value];
    }
    
    return @"";
}

@end
