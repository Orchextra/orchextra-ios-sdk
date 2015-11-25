//
//  Orchestra.m
//  Orchestra
//
//  Created by Judith Medina on 27/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "Orchextra.h"
#import "ORCConfigurationInteractor.h"

#import "ORCActionScanner.h"
#import "ORCActionVuforia.h"
#import "ORCGIGLogManager.h"


@interface Orchextra()
<ORCActionHandlerInterface, CLLocationManagerDelegate>

@property (strong, nonatomic) ORCActionManager *actionManager;
@property (strong, nonatomic) ORCConfigurationInteractor *interactor;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end


@implementation Orchextra

#pragma mark - INIT ORCHEXTRA

+ (instancetype)sharedInstance
{
    static Orchextra *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Orchextra alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:[UIApplication sharedApplication]];
    
    ORCActionManager *actionManager = [ORCActionManager sharedInstance];
    actionManager.delegateAction = self;
    ORCConfigurationInteractor *interactor = [[ORCConfigurationInteractor alloc] init];
    
    return [self initWithActionManager:actionManager
                      configInteractor:interactor];
}

- (instancetype)initWithActionManager:(ORCActionManager *)actionManager
                         configInteractor:(ORCConfigurationInteractor *)configInteractor
{
    self = [super init];
    
    if (self)
    {
        _actionManager = actionManager;
        _interactor = configInteractor;
        
        [self debug:ORCShowLogs];
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)setApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret completion:(void (^)(BOOL, NSError *))completion
{
    __weak typeof(self) this = self;
    [self.interactor loadProjectWithApiKey:apiKey apiSecret:apiSecret completion:^(NSArray *regions, NSError *error) {
        
        if (error == nil)
        {
            [ORCGIGLogManager log:@"[ORCHEXTRA] -LOADED PROJECT APIKEY: %@ - APISECRET: %@", apiKey, apiSecret];
            [this.actionManager startGeoMarketingWithRegions:regions];
            completion(YES, nil);
        }
        else
        {
            completion(NO, error);
        }
    }];
}

# pragma mark - PUBLIC (Actions)

- (void)startScanner
{
    ORCAction *barcodeAction = [[ORCAction alloc] initWithType:ORCActionOpenScannerID];
    barcodeAction.urlString = ORCSchemeScanner;
    
    [self.actionManager launchAction:barcodeAction];
}

#pragma mark - NOTIFICATION

- (void)applicationWillEnterForeground:(NSNotification *)object
{
    [self.actionManager updateUserLocation];
}

- (void)applicationDidFinishLaunching:(NSNotification *)object
{
    NSDictionary *userInfo = [object userInfo];

    if ([userInfo objectForKey:UIApplicationLaunchOptionsLocationKey] != nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
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

#pragma mark - DELEGATE

- (void)didExecuteActionWithCustomScheme:(NSString *)customScheme
{
    [self.delegate executeCustomScheme:customScheme];
}

- (BOOL)isImageRecognitionAvailable
{
    return [self.interactor isImageRecognitionAvailable];
}


- (void)debug:(BOOL)debug
{
    [ORCGIGLogManager shared].appName = @"Orchextra SDK";
    [ORCGIGLogManager shared].logEnabled = debug;
}



@end
