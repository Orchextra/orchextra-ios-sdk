//
//  GIGFileManager.h
//  giglibrary
//
//  Created by Sergio Baró on 27/06/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GIGFileManager : NSObject

@property (strong, nonatomic, readonly) NSString *rootPath;

- (instancetype)initWithRootPath:(NSString *)rootPath;
- (instancetype)initWithFileManager:(NSFileManager *)fileManager rootPath:(NSString *)rootPath;

// directories
+ (NSString *)documentsPath;
+ (NSString *)cachesPath;

// paths
- (BOOL)createPath:(NSString *)path;
- (BOOL)existsPath:(NSString *)path;
- (BOOL)removePath:(NSString *)path;

// files
- (BOOL)storeFile:(NSData *)data atPath:(NSString *)path;
- (BOOL)storeFile:(NSData *)data withName:(NSString *)name atPath:(NSString *)path;
- (NSData *)fileAtPath:(NSString *)path;
- (BOOL)removeFileAtPath:(NSString *)path;

@end
