//
//  AppDelegate.m
//  GIGLibraryApp
//
//  Created by Alejandro Jiménez Agudo on 11/5/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "AppDelegate.h"


//#if GIG_STATIC_LIBRARY

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

@end
//
//#else // GIG_DYNAMIC_LIBRARY
//
//#import "GIGSocial.h"
//
//
//@implementation AppDelegate
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//	
//    return [GIGSocialCore application:application didFinishLaunchingWithOptions:launchOptions];
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    [GIGSocialCore applicationDidBecomeActive:application];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [GIGSocialCore application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
//}
//
//@end
//
//#endif
