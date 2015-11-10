//
//  GIGLogManager.h
//  giglibrary
//
//  Created by Sergio Baró on 17/03/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ORCGIGLogMessage(message) [ORCGIGLogManager logMessage:message]
#define ORCGIGLog(format, ...) [ORCGIGLogManager log:format, ##__VA_ARGS__]
#define ORCGIGLogInfo(format, ...) [ORCGIGLogManager info:format, ##__VA_ARGS__]
#define ORCGIGLogWarn(format, ...) [ORCGIGLogManager warn:format, ##__VA_ARGS__]
#define ORCGIGLogNSError(error) [ORCGIGLogManager logError:error]
#define ORCGIGLogError(format, ...) [ORCGIGLogManager error:format, ##__VA_ARGS__]
#define ORCGIGLogException(exception) [ORCGIGLogManager logException:exception]

#define ORCGIGLogFunction() [ORCGIGLogManager log:@"%s", __PRETTY_FUNCTION__]
#define ORCGIGLogLine() [ORCGIGLogManager log:@"=============================================================================================="]
#define ORCGIGLogTitle(title) [ORCGIGLogManager log:@"--- %@ ------------------------", title]
#define ORCGIGLogDataAsString(name, data) [ORCGIGLogManager log:@"%@: %@", name, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]
#define ORCGIGLogBool(name, value) [ORCGIGLogManager log:@"%@: %@", name, value ? @"YES" : @"NO"]


@interface ORCGIGLogManager : NSObject

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
