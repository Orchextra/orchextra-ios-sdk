//
//  GIGURLConnectionBuilder.m
//  gignetwork
//
//  Created by Sergio Baró on 05/03/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLConnectionBuilder.h"

#import "ORCGIGURLParametersFormatter.h"
#import "ORCGIGURLRequest.h"


@interface ORCGIGURLConnectionBuilder ()

@property (strong, nonatomic) NSArray *queryStringMethods;
@property (strong, nonatomic) ORCGIGURLParametersFormatter *parametersFormatter;

@property (weak, nonatomic) ORCGIGURLRequest *URLRequest;

@end


@implementation ORCGIGURLConnectionBuilder

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _queryStringMethods = @[@"GET", @"HEAD"];
        _parametersFormatter = [[ORCGIGURLParametersFormatter alloc] init];
        _stringEncoding = NSUTF8StringEncoding;
        _jsonWritingOptions = 0;
    }
    return self;
}

#pragma mark - ACCESSORS

- (void)setStringEncoding:(NSStringEncoding)stringEncoding
{
    _stringEncoding = stringEncoding;
    
    self.parametersFormatter.stringEncoding = stringEncoding;
}

#pragma mark - PUBLIC

- (NSURLConnection *)buildConnectionWithRequest:(ORCGIGURLRequest<NSURLConnectionDelegate, NSURLConnectionDataDelegate> *)URLRequest;
{
    self.URLRequest = URLRequest;
    
    NSURL *URL = [self buildRequestURL];
    if (URL == nil) return nil;
    
    NSMutableURLRequest *request = [self buildRequestWithURL:URL];
    [self addBodyToRequest:request];
    
    return [NSURLConnection connectionWithRequest:request delegate:URLRequest];
}

#pragma mark - PRIVATE

- (NSURL *)buildRequestURL
{
    if ([self parametersInQueryString])
    {
        return [self.parametersFormatter URLWithParameters:self.URLRequest.parameters baseUrl:self.URLRequest.url];
    }
    else
    {
        return [NSURL URLWithString:self.URLRequest.url];
    }
}

- (NSMutableURLRequest *)buildRequestWithURL:(NSURL *)URL
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    request.HTTPMethod = self.URLRequest.method.uppercaseString;
    request.cachePolicy = self.URLRequest.cachePolicy;
    
    if (self.URLRequest.timeout > 0)
    {
        request.timeoutInterval = self.URLRequest.timeout;
    }
    
    for (NSString *header in self.URLRequest.headers)
    {
        [request setValue:self.URLRequest.headers[header] forHTTPHeaderField:header];
    }
    
    return request;
}

- (void)addBodyToRequest:(NSMutableURLRequest *)request
{
    if ([self isJSONBody])
    {
        request.HTTPBody = [self.parametersFormatter jsonBodyWithParameters:self.URLRequest.json error:nil];
        [self addJSONHeadersToRequest:request];
    }
    else if ([self isMultipart])
    {
        NSString *boundary = [self.parametersFormatter generateBoundary];
        request.HTTPBody = [self.parametersFormatter multipartBodyWithParameters:self.URLRequest.parameters files:self.URLRequest.files boundary:boundary];
        [self addMultipartHeadersToRequest:request boundary:boundary];
    }
    else if ([self parametersInBody])
    {
        request.HTTPBody = [self.parametersFormatter bodyWithParameters:self.URLRequest.parameters];
    }
}

- (BOOL)parametersInQueryString
{
    return ([self.queryStringMethods containsObject:self.URLRequest.method.uppercaseString] && self.URLRequest.parameters.count > 0);
}

- (BOOL)parametersInBody
{
    return (![self.queryStringMethods containsObject:self.URLRequest.method.uppercaseString] && self.URLRequest.parameters.count > 0);
}

- (BOOL)isMultipart
{
    return (![self.queryStringMethods containsObject:self.URLRequest.method.uppercaseString] && self.URLRequest.files.count > 0);
}

- (BOOL)isJSONBody
{
    return (![self.queryStringMethods containsObject:self.URLRequest.method.uppercaseString] && self.URLRequest.json.count > 0);
}

- (void)addJSONHeadersToRequest:(NSMutableURLRequest *)request
{
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
    [request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
}

- (void)addMultipartHeadersToRequest:(NSMutableURLRequest *)request boundary:(NSString *)boundary
{
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSString *contentLength = [NSString stringWithFormat:@"%ld", (long)request.HTTPBody.length];
    [request addValue:contentLength forHTTPHeaderField:@"Content-Length"];
}

@end
