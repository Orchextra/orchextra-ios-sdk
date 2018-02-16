//
//  ORCApplicationCenter.m
//  Orchextra
//
//  Created by Judith Medina on 4/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCApplicationCenter.h"
#import "ORCPushManager.h"
#import "ORCActionManager.h"
#import "ORCSettingsInteractor.h"
#import "ORCSettingsPersister.h"
#import "ORCConstants.h"

#define kBACKGROUND_TASK_RANGING @"BackgroundTaskRangingBeacons"

@interface ORCApplicationCenter ()
<CLLocationManagerDelegate>

@property (strong, nonatomic) NSNotificationCenter *notificationCenter;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) ORCActionManager *actionManager;
@property (strong, nonatomic) ORCSettingsInteractor *settingsInteractor;

@end

@implementation ORCApplicationCenter
{
    CLLocationManager *_locationManager;
    UIBackgroundTaskIdentifier _backgroundTask;
    Boolean _inBackground;
    NSInteger _secondsRunningInBackground;
    NSInteger _limitBackgroundRangingTime;
}

- (instancetype)init
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    ORCActionManager *actionManager          = [ORCActionManager sharedInstance];
    ORCSettingsInteractor *settingsInteractor = [[ORCSettingsInteractor alloc] init];
    
    return [self initWithNotificationCenter:notificationCenter
                              actionManager:actionManager
                                    settingsInteractor:settingsInteractor];
}

- (instancetype)initWithNotificationCenter:(NSNotificationCenter *)notificationCenter
                             actionManager:(ORCActionManager *)actionManager
                          settingsInteractor:(ORCSettingsInteractor *)settingsInteractor
{
    self = [super init];
    
    if (self)
    {
        _notificationCenter = notificationCenter;
        _actionManager      = actionManager;
        _settingsInteractor  = settingsInteractor;
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)startObservingAppDelegateEvents
{
    [self.notificationCenter addObserver:self
                                selector:@selector(applicationDidFinishLaunching:)
                                    name:UIApplicationDidFinishLaunchingNotification
                                  object:[UIApplication sharedApplication]];
    
    [self.notificationCenter addObserver:self
                                selector:@selector(applicationWillEnterForeground:)
                                    name:UIApplicationWillEnterForegroundNotification
                                  object:[UIApplication sharedApplication]];

    [self.notificationCenter addObserver:self
                                selector:@selector(applicationDidEnterForeground:)
                                    name:UIApplicationDidEnterBackgroundNotification
                                  object:[UIApplication sharedApplication]];
    
    [self.notificationCenter addObserver:self
                                selector:@selector(applicationWillResignActive:)
                                    name:UIApplicationWillResignActiveNotification
                                  object:[UIApplication sharedApplication]];
    
    [self.notificationCenter addObserver:self
                                selector:@selector(applicationDidBecomeActive:)
                                    name:UIApplicationDidBecomeActiveNotification
                                  object:[UIApplication sharedApplication]];
    
    [self.notificationCenter addObserver:self
                                selector:@selector(applicationWillTerminate:)
                                    name:UIApplicationWillTerminateNotification
                                  object:[UIApplication sharedApplication]];
}

- (void)stopObservingAppDelegateEvens
{
    [self removeObservers];
}

- (void)extendBackgroundRunningTime
{
    if (_backgroundTask != UIBackgroundTaskInvalid)
    {
        return;
    }
    
    [[ORCLog sharedInstance] logVerbose:@"Attempting to extend background running time: %d", _limitBackgroundRangingTime];
    
    __block Boolean self_terminate = YES;
    _secondsRunningInBackground = 0;
    
    _backgroundTask = [[UIApplication sharedApplication]
                       beginBackgroundTaskWithName:kBACKGROUND_TASK_RANGING expirationHandler:^{
                           
                           if (self_terminate)
                           {
                               [self endExtendBackgroundTask];
                           }
                       }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[ORCLog sharedInstance] logVerbose:@"Background task started"];
        
        while (_secondsRunningInBackground < _limitBackgroundRangingTime) {
            
            [NSThread sleepForTimeInterval:1];
            _secondsRunningInBackground++;
            
            if (_secondsRunningInBackground == _limitBackgroundRangingTime)
            {
                [self endExtendBackgroundTask];
            }
        }
    });
}


#pragma mark - PRIVATE (AppDelegate Events)

- (void)applicationWillEnterForeground:(NSNotification *)object
{
    [[ORCLog sharedInstance] logVerbose:@"applicationWillEnterForeground"];
    [self updateConfiguration];
}

- (void)applicationDidEnterForeground:(NSNotification *)object
{
    [[ORCLog sharedInstance] logVerbose:@"applicationDidEnterForeground"];
    [self haveToExtendBackgroundTime];
    _inBackground = YES;
}

- (void)applicationWillResignActive:(NSNotification *)object
{
    [[ORCLog sharedInstance] logVerbose:@"applicationWillResignActive"];
}

- (void)applicationDidBecomeActive:(NSNotification *)object
{
    [[ORCLog sharedInstance] logVerbose:@"applicationDidBecomeActive"];
    _inBackground = NO;
}

- (void)applicationWillTerminate:(NSNotification *)object
{
    [[ORCLog sharedInstance] logVerbose:@"applicationWillTerminate"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)object
{
    [[ORCLog sharedInstance] logVerbose:@"applicationDidFinishLaunching"];
    
    _backgroundTask = UIBackgroundTaskInvalid;
    _inBackground = YES;
    _limitBackgroundRangingTime = [self.settingsInteractor backgroundTime];
    
    NSDictionary *userInfo = [object userInfo];
    
    if ([userInfo objectForKey:UIApplicationLaunchOptionsLocationKey] != nil)
    {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    else if ([userInfo objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey])
    {
        [ORCPushManager handlePush:[userInfo objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
    }
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if (_inBackground)
    {
        [self haveToExtendBackgroundTime];
    }
}

#pragma mark - PRIVATE

- (void)updateConfiguration
{
    [self.actionManager performUpdateUserLocation];
}

- (void)haveToExtendBackgroundTime
{
    _limitBackgroundRangingTime = [self.settingsInteractor backgroundTime];
    
    if (_limitBackgroundRangingTime > DEFAULT_BACKGROUND_TIME)
    {
        [self extendBackgroundRunningTime];
    }
}

- (void)endExtendBackgroundTask
{
    [[ORCLog sharedInstance] logVerbose:@"Background task expired"];
    [[UIApplication sharedApplication] endBackgroundTask:_backgroundTask];
    _backgroundTask = UIBackgroundTaskInvalid;
}

- (void)removeObservers
{
    [self.notificationCenter removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:nil];
    [self.notificationCenter removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [self.notificationCenter removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [self.notificationCenter removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [self.notificationCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.notificationCenter removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

#pragma mark - DEALLOC

- (void)dealloc
{    
    [self removeObservers];
}

@end

