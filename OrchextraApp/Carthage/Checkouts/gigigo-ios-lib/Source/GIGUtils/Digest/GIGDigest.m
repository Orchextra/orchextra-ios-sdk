//
//  GIGDigest.m
//  giglibrary
//
//  Created by Sergio Baró on 10/04/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import "GIGDigest.h"

#import <CommonCrypto/CommonDigest.h>


@implementation GIGDigest

+ (NSString *)MD5:(id)data
{
    if ([data isKindOfClass:[NSString class]])
    {
        return [self md5String:data];
    }
    else
    {
        return [self md5Data:data];
    }
}

+ (NSString *)SHA1:(id)data
{
    if ([data isKindOfClass:[NSString class]])
    {
        return [self sha1String:data];
    }
    else
    {
        return [self sha1Data:data];
    }
}

+ (NSString *)SHA256:(id)data
{
    if ([data isKindOfClass:[NSString class]])
    {
        return [self sha256String:data];
    }
    else
    {
        return [self sha256Data:data];
    }
}

+ (NSString *)SHA512:(id)data
{
    if ([data isKindOfClass:[NSString class]])
    {
        return [self sha512String:data];
    }
    else
    {
        return [self sha512Data:data];
    }
}

#pragma mark - Private

+ (NSString *)sha1String:(NSString *)string
{
	const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:string.length];
	
	return [self sha1Data:data];
}

+ (NSString *)md5String:(NSString *)string
{
	const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:string.length];
	
	return [self md5Data:data];
}

+ (NSString *)sha256String:(NSString *)string
{
	const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:string.length];
	
	return [self sha256Data:data];
}

+ (NSString *)sha512String:(NSString *)string
{
	const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:string.length];
	
	return [self sha512Data:data];
}

+ (NSString *)sha1Data:(NSData *)data
{
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	
	CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
	for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
	{
		[output appendFormat:@"%02x", digest[i]];
	}
	
	return output;
}

+ (NSString *)md5Data:(NSData *)data
{
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5(data.bytes, (CC_LONG)data.length, digest);
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
	{
		[output appendFormat:@"%02x", digest[i]];
	}
	
	return  output;
}

+ (NSString *)sha256Data:(NSData *)data
{
	uint8_t digest[CC_SHA256_DIGEST_LENGTH];
	
	CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
	for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
	{
		[output appendFormat:@"%02x", digest[i]];
	}
	
	return output;
}

+ (NSString *)sha512Data:(NSData *)data
{
	uint8_t digest[CC_SHA512_DIGEST_LENGTH];
	
	CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
	for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
	{
		[output appendFormat:@"%02x", digest[i]];
	}
	
	return output;
}

@end
