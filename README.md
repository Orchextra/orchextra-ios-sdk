# Orchextra SDK for iOS

A library that gives you access to Orchextra platform from your iOS app. 

### Getting started
Start by creating a project in Orchextra dashboard “dashboard.orchextra.io”, if you haven't done it yet. Go to "Setting" > "SDK Configuration" to get the **api key** and **api secret**, you will need these values to start Orchextra SDK.

### Download SDK
To use Orchextra, head on over to the [releases] page, and download the latest build.
Drag and drop **Orchextra.framework** and **Orchextra.bundle** into your xCode project folder target. 

Make sure the framework is linked:
* Click on Targets  → Your app name  → and then the Build Phases tab 
* Expand "Link With Libraries" to check that Orchextra.framework is there. 
* Also expand "Copy bundle resources" to make sure that Orchextra.bundle is also there.

### Add the dependencies
Click the + button in the bottom left of the 'Link Binary With Libraries' section and add the following libraries:

* AdSupport.framework
* SystemConfiguration.framework
* AVFoundation.framework
* CoreLocation.framework
* CoreMotion.framework

You also need to add in "Build Settings" tab:
 
* "Other Linker Flags" the next flags: **-ObjC**  and **-lc++** 
* "Enable Bitcode" setup the value to **NO**.

### Configure Info.plist
You have to provide (it is required) a description of "why the app wants to use location services" in the info.plist
by using the following keys and providing an string with the reason.

* NSLocationAlwaysUsageDescription
* NSLocationWhenInUseUsageDescription

### Integrate Orchextra SDK
Open up your AppDelegate.m and add the following to it:

```objective-c
#import <Orchextra/Orchextra.h>
#define ORCHEXTRA_API_KEY @"YOUR_API_KEY"
#define ORCHEXTRA_API_SECRET @"YOUR_API_SECRET"
  
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[Orchextra sharedInstance] setApiKey:ORCHEXTRA_API_KEY apiSecret:ORCHEXTRA_API_SECRET
                                completion:^(BOOL success, NSError *error) {
    }];
    return YES;
} 
```

### Add user to Orchextra
ORCUser class is a local representation of a user persisted to the Orchextra Database to help to create a good user segmentation. This object is optional and could be set up at any time, "currentUser" this method will return the latest user stored in the database or in case there isn't any value will return an empty ORCUser instance. 

```objective-c
/* Get current Orchextra user */
ORCUser *user = [ORCUser currentUser];
user.crmID = ORCHEXTRA_CRM_ID;
user.tags = @[@"keyword1", @"keyword2"];
user.birthday = [NSDate date];
user.gender = ORCGenderFemale;
  
/* Save Orchextra user */
[user saveUser];
```
### Custom Scheme - Delegate
In order to get custom schemes within our app AppDelegate must conform the OrchextraCustomActionDelegate protocol, the following method will handle all the custom scheme created in Orchextra.

```objective-c
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

###  Push Notification 

First of all you have to register your app for remote notification by adding the following in your AppDelegate.m.

```objective-c
#pragma mark - NOTIFICATION DELEGATION
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    [ORCPushManager storeDeviceToken:devToken];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [ORCPushManager handlePush:notification];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [ORCPushManager handlePush:userInfo];
} 
```

###  Start Actions 
Orchextra SDK let you invoke a couple of action within your own application to start a new user journey

#### Scanner
To launch the scanner you just need to add the following line to the action. 
```objective-c
[[Orchextra sharedInstance] startScanner];
```
#### Image Recognization
To launch the image recognition action you just need to add the following line to the action.
This option is only available if you have a Vuforia account with a cloud database. 
```objective-c
[[Orchextra sharedInstance] startImageRecognition];
```
