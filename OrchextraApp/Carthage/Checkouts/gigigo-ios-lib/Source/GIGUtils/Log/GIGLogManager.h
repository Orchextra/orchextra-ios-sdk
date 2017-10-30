//
//  GIGLogManager.h
//  giglibrary
//
//  Created by Sergio Baró on 17/03/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GIGLogMessage(message) [GIGLogManager logMessage:message]
#define GIGLog(format, ...) [GIGLogManager log:format, ##__VA_ARGS__]
#define GIGLogInfo(format, ...) [GIGLogManager info:format, ##__VA_ARGS__]
#define GIGLogWarn(format, ...) [GIGLogManager warn:format, ##__VA_ARGS__]
#define GIGLogNSError(error) [GIGLogManager logError:error]
#define GIGLogError(format, ...) [GIGLogManager error:format, ##__VA_ARGS__]
#define GIGLogException(exception) [GIGLogManager logException:exception]

#define GIGLogFunction() [GIGLogManager log:@"%s", __PRETTY_FUNCTION__]
#define GIGLogLine() [GIGLogManager log:@"=============================================================================================="]
#define GIGLogTitle(title) [GIGLogManager log:@"--- %@ ------------------------", title]
#define GIGLogDataAsString(name, data) [GIGLogManager log:@"%@: %@", name, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]
#define GIGLogBool(name, value) [GIGLogManager log:@"%@: %@", name, value ? @"YES" : @"NO"]


@interface GIGLogManager : NSObject

@property (strong, nonatomic) NSString *appName;
@property (assign, nonatomic) BOOL logEnabled;

+ (instancetype)shared;

+ (void)logMessage:(NSString *)message;
+ (void)log:(NSString *)format, ...;
+ (void)info:(NSString *)format, ...;
+ (void)warn:(NSString *)format, ...;
+ (void)error:(NSString *)format, ...;
+ (void)logError:(NSError *)error;
+ (void)logException:(NSException *)exception;

@end
