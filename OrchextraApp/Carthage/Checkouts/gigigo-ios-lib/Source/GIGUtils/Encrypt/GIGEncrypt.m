//
//  GIGEncrypt.m
//  giglibrary
//
//  Created by Sergio Baró on 28/04/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import "GIGEncrypt.h"

#import <CommonCrypto/CommonCrypto.h>


@implementation GIGEncrypt

#pragma mark - Public

+ (NSData *)AES128:(NSData *)data key:(NSString *)key
{
	return [self AES128:data operation:kCCEncrypt key:key];
}

+ (NSData *)decryptAES128:(NSData *)data key:(NSString *)key
{
	return [self AES128:data operation:kCCDecrypt key:key];
}

+ (NSData *)AES256:(NSData *)data key:(NSString *)key
{
    return [self AES256:data operation:kCCEncrypt key:key];
}

+ (NSData *)decryptAES256:(NSData *)data key:(NSString *)key
{
    return [self AES256:data operation:kCCDecrypt key:key];
}

#pragma mark - Private

+ (NSData *)AES128:(NSData *)plainData operation:(CCOperation)operation key:(NSString *)key
{
    const void *vplainText = (const void *)[plainData bytes];
    size_t plainTextBufferSize = plainData.length;
	
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
	
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *) [key UTF8String];
	
    ccStatus = CCCrypt(operation,
                       kCCAlgorithmAES128,
                       kCCOptionECBMode | kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySizeAES128,
                       NULL,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *result = nil;
    if (ccStatus == kCCSuccess)
    {
        result = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    }
    free(bufferPtr);
	
    return result;
}

+ (NSData *)AES256:(NSData *)plainData operation:(CCOperation)operation key:(NSString *)key
{
    const void *vplainText = (const void *)[plainData bytes];
    size_t plainTextBufferSize = plainData.length;
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *) [key UTF8String];
    
    ccStatus = CCCrypt(operation,
                       kCCAlgorithmAES128,
                       kCCOptionECBMode | kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySizeAES256,
                       NULL,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *result = nil;
    if (ccStatus == kCCSuccess)
    {
        result = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    }
    free(bufferPtr);
    
    return result;
}


@end
