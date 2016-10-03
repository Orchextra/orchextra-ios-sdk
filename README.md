# Orchextra SDK for iOS
![Language](https://img.shields.io/badge/Language-Objective--C-orange.svg)
![Version](https://img.shields.io/badge/version-2.0.7-blue.svg)
[![Build Status](https://travis-ci.org/Orchextra/orchextra-ios-sdk.svg?branch=master)](https://travis-ci.org/Orchextra/orchextra-ios-sdk)
[![codecov.io](https://codecov.io/github/Orchextra/orchextra-ios-sdk/coverage.svg?branch=develop)](https://codecov.io/github/Orchextra/orchextra-ios-sdk?branch=master)

A library that gives you access to Orchextra platform from your iOS app.

## Getting started
Start by creating a project in [Orchextra dashboard][dashboard], if you haven't done it yet. Go to "Setting" > "SDK Configuration" to get the **api key** and **api secret**, you will need these values to start Orchextra SDK.

## Overview
Orchextra SDK is composed of **Orchextra Core** and **Vuforia Orchextra** as an Add-on, which means that you need to have installed the *Core* in the first instance in order to use *Vuforia*. This division has been done to allow you decide if you want to include image recognition in your apps or just the main functionality.  
#### Orchextra Core
- Geofences
- Beacons
- Scan QR/Barcodes
#### Vuforia Orchextra (Add-on)
- Image recognition (Supports Vuforia)

## Installation
Download [*Orchextra iOS-Sample-App*][ios-sample-app] to understand how to use the SDK.

### Requirements
- iOS 7 or later

### Download SDK
To use *Orchextra Core*, head on over to the [releases][releases] page, and download the latest build "Orchextra.zip".
Drag and drop **Orchextra.framework** and **Orchextra.bundle** into your xCode project folder target. To use image recognition, drag and drop **VuforiaOrchextra.framework** into your xCode project.

Make sure the framework is linked:
* Click on Targets  → Your app name  → and then the Build Phases tab
* Expand "Link With Libraries" to check that Orchextra.framework is there.
* Also expand "Copy bundle resources" to make sure that Orchextra.bundle is also there.
*Note*: If you have added *VuforiaOrchextra.framework* check as well that is in "Link With Libraries".

### Add the dependencies
Click the + button in the bottom left of the 'Link Binary With Libraries' section and add the following libraries:

#### Core dependencies
* AdSupport.framework
* AVFoundation.framework
* CoreLocation.framework
* PassKit.framework
* WebKit.framework
* SafariServices.framework


#### Vuforia dependencies
* SystemConfiguration.framework
* CoreMotion.framework
* CoreMedia.framework

You also need to add in "Build Settings" tab:

* "Other Linker Flags" the next flags: **-ObjC**  and **-lc++**
* "Enable Bitcode" setup the value to **NO**.

### Geolocation - Configure Info.plist
You have to provide (it is required) a description of "why the app wants to use location services" in the info.plist
by using the following keys and providing an string with the reason.

* NSLocationAlwaysUsageDescription
* NSLocationWhenInUseUsageDescription

## Integrate Orchextra SDK
Open up your AppDelegate.m and add the following to it:

```objective-c
#import <Orchextra/Orchextra.h>

#define ORCHEXTRA_API_KEY @"YOUR_API_KEY"
#define ORCHEXTRA_API_SECRET @"YOUR_API_SECRET"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

[[Orchextra sharedInstance] setApiKey:ORCHEXTRA_API_KEY apiSecret:ORCHEXTRA_API_SECRET
completion:^(BOOL success, NSError *error) {
if (success)
{
NSLog(@"ORCHEXTRA has loaded successfully");
}
else {
NSLog(@"ORCHEXTRA ERROR: %@", error.localizedDescription);
}

}];

/* Uncomment this line to get the debug logs
[Orchextra logLevel:ORCLogLevelDebug];
*/

return YES;
}
```


##  Local & Remote Push Notification
Orchextra offers you the chance to show notifications to the user when an action is launched, add
the following method to use the local push notification to inform your users about actions when the app is in the background.

```objective-c
#pragma mark - NOTIFICATION ( Local Push Notification)
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
[ORCPushManager handlePush:notification];
}
```

To use remote push notification register your app by adding the following in your AppDelegate.m

```objective-c
#pragma mark - NOTIFICATION ( Remote Push Notification)
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
[ORCPushManager storeDeviceToken:devToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
[ORCPushManager handlePush:userInfo];
}
```

## Custom Scheme - Delegate
In order to get custom schemes within our app AppDelegate must conform the OrchextraCustomActionDelegate protocol, the following method will handle all the custom schemes created in Orchextra.

```objective-c

@interface AppDelegate ()
<OrchextraCustomActionDelegate>
@end

// Conform delegate with Orchextra object
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//....... Code........//
[[Orchextra sharedInstance] setDelegate:self];
}

#pragma mark - Orchextra CustomAction Delegate
// Method to handle custom schemes
- (void)executeCustomScheme:(NSString *)scheme
{
/* Code to handle custom scheme */
}
```

## Bind user to Orchextra
ORCUser class is a local representation of a user persisted to the Orchextra Database to help to create a good user segmentation. This object is optional and could be set up at any time, "currentUser" this method will return the latest user stored in the database or in case there isn't any value will return an empty ORCUser instance.

```objective-c
/* Get current Orchextra user */
Orchextra *orchextra = [Orchextra sharedInstance];
ORCUser *user = [orchextra currentUser];
user.crmID = ORCHEXTRA_CRM_ID;
user.tags = @[@"keyword1", @"keyword2"];
user.birthday = [NSDate date];
user.gender = ORCGenderFemale;

/* Save Orchextra user */
[orchextra bindUser:user];
```

## Unbind user to Orchextra
ORCUser information will be set to nil. Current user will be an empty object now.

```objective-c
[[Orchextra sharedInstance] unbindUser];
```

## Segmentation
Orchextra SDK allows to create segmentation using tags, business units or custom fields. This segmentation can be performed by user or by device.

### Segmentation by device
Device segmentation can be created by using tags or business units.

#### Using tags
You can set new device tags:

```objective-c
ORCTag *countryTag = [[ORCTag alloc] initWithPrefix:@"country" name:@"Spain"];
NSArray <ORCTag *> *deviceTags = [NSArray arrayWithObjects:countryTag, nil];
    
[[Orchextra sharedInstance] setDeviceTags:deviceTags];
```
You can get device tags:

```objective-c
NSArray <ORCTag *> *deviceTags = [[Orchextra sharedInstance] getDeviceTags];
```

#### Using business units
You can set new device business units:

```objective-c
ORCBusinessUnit *businessUnit1 = [[ORCBusinessUnit alloc] initWithPrefix:@"bu1"];
ORCBusinessUnit *businessUnit2 = [[ORCBusinessUnit alloc] initWithPrefix:@"bu2"];   
NSArray <ORCBusinessUnit *> *deviceBusinessUnits = [NSArray arrayWithObjects:businessUnit1, businessUnit2, nil];

[[Orchextra sharedInstance] setDeviceBussinessUnits:deviceBusinessUnits];
```
You can get device business unit:

```objective-c
NSArray <ORCBusinessUnit *> *deviceBusinessUnits = [[Orchextra sharedInstance] getDeviceBusinessUnits];
```

### Segmentation by user
User segmentation can be created by using tags, business units or custom fields.

#### Using tags
You can set new user tags:

```objective-c
ORCTag *countryTag = [[ORCTag alloc] initWithPrefix:@"country" name:@"Spain"];
NSArray <ORCTag *> *userTags = [NSArray arrayWithObjects:countryTag, nil];
    
[[Orchextra sharedInstance] setUserTags:userTags];
```
You can get user tags:

```objective-c
NSArray <ORCTag *> *userTags = [[Orchextra sharedInstance] getUserTags];
```

#### Using business units
You can set new user business units:

```objective-c
ORCBusinessUnit *businessUnit1 = [[ORCBusinessUnit alloc] initWithPrefix:@"bu1"];
ORCBusinessUnit *businessUnit2 = [[ORCBusinessUnit alloc] initWithPrefix:@"bu2"];   
NSArray <ORCBusinessUnit *> *userBusinessUnits = [NSArray arrayWithObjects:businessUnit1, businessUnit2, nil];

[[Orchextra sharedInstance] setUserBussinessUnits:deviceBusinessUnits];
```
You can get user business unit:

```objective-c
NSArray <ORCBusinessUnit *> *userBusinessUnits = [[Orchextra sharedInstance] getUserBusinessUnits];
```

#### Using custom fields
You can set new custom fields:

```objective-c
ORCCustomField *customField = [[ORCCustomField alloc] initWithKey:@"key" label:@"label" type:ORCCustomFieldTypeString value:@"value"];
NSArray <ORCCustomField *> *customFields = [NSArray arrayWithObjects:customField, nil];
    
[[Orchextra sharedInstance] setCustomFields:customFields];
```
You can get custom fields:

```objective-c
NSArray <ORCCustomField *> * customFields =  [[Orchextra sharedInstance] getCustomFields];
```

You can update custom field value. Custom field key has to exist to update its value:

```objective-c
[[Orchextra sharedInstance] updateCustomFieldValue:@"value2" withKey:@"key"];
```

### Commit configuration

Afer set segmentation information is required to commit back this to refresh new values.

```objective-c
[[Orchextra sharedInstance] commitConfiguration];
```

##  Start Actions
Orchextra SDK let you invoke a couple of action within your own application to start a new user journey

### Scanner
This functionality is included in Orchextra.framework.

To launch the scanner you just need to add the following line to the action.
```objective-c
[[Orchextra sharedInstance] startScanner];
```
### Image Recognition
This functionality is included in VuforiaOrchextra.framework, to use it first of all you have to add the framework in the class that need to use this feature:
```objective-c
<VuforiaOrchextra/VuforiaOrchextra.h>
```

To launch the image recognition action you just need to add the following line to the action.
This option is only available if you have a Vuforia account with a cloud database.
```objective-c
[[VuforiaOrchextra sharedInstance] startImageRecognition];
```
##  How to Get Extra Ranging Time
One of the most common use cases for beacon applications is to perform an action when a user gets close to a specific location. This approach is problematic on iOS, because CoreLocation generally allows only 10 seconds of ranging time when an app is in the background. So if a beacons is first detected at 50 meters and a person is approaching the beacon, once the user arrives at the right location the iOS app would have been already suspended and stopped it from ranging. 

Fortunately, Orchextra allows to extend the background ranging time up to 180 seconds, you can see below an example of how to get extra time if need it. 
```objective-c
ORCSettingsDataManager *settingsDM = [[ORCSettingsDataManager alloc] init];
[settingsDM extendBackgroundTime:YOUR_BACKGROUND_TIME];
```

##  Logs

Orchextra gives you the possibility to show 5 levels of logs.
```
ORCLogLevelOff       -> No logs of Orchextra
ORCLogLevelError     -> Only Error logs 
ORCLogLevelWarning   -> Warning and error logs
ORCLogLevelDebug     -> Debug information (Recommended for Developers to get debug information about Orchextra)  
ORCLogLevelAll       -> All logs (Displays all logs requests and responses from network, debug, errors and warnings)
```

#### How to set up logs

By default Orchextra has only error level, so if you want to change the level of information you will need to add the next lines:
```
[Orchextra logLevel:ORCLogLevelDebug];
```

## Custom Theme

To customize your view (navigation bar, title color, etc...), you will have to do it from your code, below there is a code snippet that will help you to do it. ;)

```objective-c
- (void)customizeTheme
{
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:__BACKGROUND_BAR_COLOR__];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : __TITLE_COLOR__}];
    [[UINavigationBar appearance] setTintColor:__BUTTON_BAR_COLOR__];
}
```

[releases]: https://github.com/Orchextra/orchextra-ios-sdk/releases
[dashboard]: https://dashboard.orchextra.io
[ios-sample-app]: https://github.com/Orchextra/orchextra-ios-sample-app
