//
//  Orchestra.m
//  Orchestra
//
//  Created by Judith Medina on 27/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "Orchextra.h"
#import "ORCSettingsInteractor.h"
#import "ORCApplicationCenter.h"
#import "ORCActionScanner.h"
#import "ORCURLProvider.h"

@interface Orchextra()
<ORCActionHandlerInterface, CLLocationManagerDelegate>

@property (strong, nonatomic) ORCActionManager *actionManager;
@property (strong, nonatomic) ORCSettingsInteractor *interactor;
@property (strong, nonatomic) ORCWebViewViewController *webviewOrchextra;

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
    ORCActionManager *actionManager = [ORCActionManager sharedInstance];
    actionManager.delegateAction = self;
    
    ORCSettingsInteractor *interactor = [[ORCSettingsInteractor alloc] init];
    ORCApplicationCenter *applicationCenter = [[ORCApplicationCenter alloc] init];
    
    return [self initWithActionManager:actionManager
                      configInteractor:interactor
                     applicationCenter:applicationCenter];
}

- (instancetype)initWithActionManager:(ORCActionManager *)actionManager
                         configInteractor:(ORCSettingsInteractor *)configInteractor
                    applicationCenter:(ORCApplicationCenter *)applicationCenter

{
    self = [super init];
    
    if (self)
    {
        _actionManager = actionManager;
        _interactor = configInteractor;
        _applicationCenter = applicationCenter;

        // Set up to error level by default.
        [Orchextra logLevel:ORCLogLevelError];
        [Orchextra saveLogsToAFile];
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)setApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret completion:(void (^)(BOOL, NSError *))completion
{
    __weak typeof(self) this = self;
    [self.interactor loadProjectWithApiKey:apiKey apiSecret:apiSecret completion:^(BOOL success, NSError *error) {
        
        if (success)
        {
            [ORCLog logDebug:@" ---  ORCHEXTRA INFO --- "];
            [ORCLog logDebug:@" ---  SDK Version: %@", ORCSDKVersion];
            [ORCLog logDebug:@" ---  Endpoint SDK: %@", [ORCURLProvider domain]];

            [ORCLog logDebug:@"LOADED PROJECT WITH: "];
            [ORCLog logDebug:@"- APIKEY: %@", apiKey];
            [ORCLog logDebug:@"- API SECRET: %@", apiSecret];

            [this.applicationCenter startObservingAppDelegateEvents];
            [this.actionManager startWithAppConfiguration];
            [this.interactor saveOrchextraRunning:YES];

        }
        else
        {
            [ORCLog logError:error.debugDescription];

            // If an error has occurred then we stop orchextra services.
            [this.interactor saveOrchextraRunning:NO];
        }
        
        if (completion)
        {
            completion(success, error);
        }
    }];
}

#pragma mark - PUBLIC ()

- (void)bindUser:(ORCUser *)user
{
    [self.interactor saveUser:user];
}

- (void)unbindUser
{
    ORCUser *user = [[ORCUser alloc] init];
    [self.interactor saveUser:user];
}

- (ORCUser *)currentUser
{
    return [self.interactor currentUser];
}

- (void)commitConfiguration
{
    [self.interactor commitConfiguration];
}

- (BOOL)orchextraRunning
{
    return [self.interactor isOrchextraRunning];
}

# pragma mark - PUBLIC (Actions)

- (void)startScanner
{
    ORCAction *barcodeAction = [[ORCAction alloc] initWithType:ORCActionOpenScannerID];
    barcodeAction.urlString = ORCSchemeScanner;
    [self.actionManager launchAction:barcodeAction];
}

- (void)stopOrchextraServices
{
    [self.applicationCenter stopObservingAppDelegateEvens];
    [self.actionManager stopMonitoringAndRanging];

    [self.interactor saveOrchextraRunning:NO];
    [ORCLog logDebug:@"Stoping Orchextra Services"];
}

- (ORCWebViewViewController *)getOrchextraWebViewWithURLWithString:(NSString *)urlString
{
    if (!self.webviewOrchextra)
    {
        self.webviewOrchextra = [[ORCWebViewViewController alloc]
                                 initWithActionManager:self.actionManager];
    }
    
    [self.webviewOrchextra startWithURLString:urlString];
   
    return self.webviewOrchextra;
}

#pragma mark - PUBLIC (CustomFields)

- (NSArray <ORCCustomField *> *)getAvailableCustomFields
{
    return [self.interactor loadAvailableCustomFields];
}

- (NSArray <ORCCustomField *> *)getCustomFields
{
   return [self.interactor loadCustomFields];
}

- (void)setCustomFields:(NSArray <ORCCustomField *> *)customFields
{
    [self.interactor saveCustomFields:customFields];
}

- (BOOL)updateCustomFieldValue:(id)value withKey:(NSString *)key
{
    return [self.interactor updateCustomFieldValue:value withKey:key];
}

#pragma mark - PUBLIC (User tags)

- (NSArray <ORCTag *> *)getUserTags
{
    return [self.interactor loadUserTags];
}

- (void)setUserTags:(NSArray <ORCTag *> *)userTags
{
    [self.interactor saveUserTags:userTags];
}

#pragma mark - PUBLIC (Device tags)

- (NSArray <ORCTag *> *)getDeviceTags
{
    return [self.interactor loadDeviceTags];
}

- (void)setDeviceTags:(NSArray <ORCTag *> *)deviceTags
{
    [self.interactor saveDeviceTags:deviceTags];
}

#pragma mark - PUBLIC (User business unit)

- (NSArray <ORCBusinessUnit *> *)getUserBusinessUnits
{
    return [self.interactor loadUserBusinessUnits];
}

- (void)setUserBusinessUnits:(NSArray <ORCBusinessUnit *> *)businessUnits
{
    [self.interactor saveUserBusinessUnits:businessUnits];
}

#pragma mark - PUBLIC (Device business unit)

- (NSArray <ORCBusinessUnit *> *)getDeviceBusinessUnits
{
    return [self.interactor loadDeviceBusinessUnits];
}

- (void)setDeviceBussinessUnits:(NSArray <ORCBusinessUnit *> *)deviceBusinessUnits
{
    [self.interactor saveDeviceBusinessUnits:deviceBusinessUnits];
}

#pragma mark - DELEGATE

- (void)didExecuteActionWithCustomScheme:(NSString *)customScheme
{
    NSString *urlString = [self URLToReloadWebView:customScheme];

    if (urlString)
    {
        [self.webviewOrchextra reloadURLString:urlString];
    }
    else
    {
        [self.delegate executeCustomScheme:customScheme];
    }
}

+ (void)logLevel:(ORCLogLevel)logLevel
{    
    [ORCLog logLevel:logLevel];
}

+ (void)saveLogsToAFile
{
    [ORCLog addLogsToFile];
}

#pragma mark - PRIVATE 

- (NSString *)URLToReloadWebView:(NSString *)customScheme
{
    NSArray *components = [customScheme
                           componentsSeparatedByString:ORCHEXTRA_TO_LOADURL];
    
    if (components.count > 1)
    {
        return components[1];
    }
    
    return nil;
}

@end
