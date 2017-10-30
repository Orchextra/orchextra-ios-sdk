//
//  NSBundle+GIGExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 15/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "NSBundle+GIGExtension.h"


@implementation NSBundle (GIGExtension)

+ (NSString *)version
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)build
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *)productName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

- (NSData *)dataForFile:(NSString *)fileName
{
    NSString *filePath = [self pathForResource:fileName ofType:nil];
    if (!filePath) return nil;
    
    NSError *error = nil;
    NSData *fileData = [NSData dataWithContentsOfFile:filePath options:kNilOptions error:&error];
    if (error)
    {
        NSLog(@"ERROR: %@", error.localizedDescription);
    }
    
    return fileData;
}

- (id)loadJSONFile:(NSString *)jsonFile rootNode:(NSString *)rootNode
{
    NSData *jsonData = [self dataForFile:jsonFile];
    if (!jsonData) return nil;
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error)
    {
        NSLog(@"ERROR: %@", error.localizedDescription);
    }
    
    return (rootNode.length > 0) ? json[rootNode] : json;
}


@end
