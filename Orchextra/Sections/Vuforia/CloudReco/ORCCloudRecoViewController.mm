/*===============================================================================
Copyright (c) 2012-2015 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.
===============================================================================*/

#include "TargetConditionals.h"

#if !TARGET_IPHONE_SIMULATOR

#import "ORCCloudRecoViewController.h"
#import <QCAR/QCAR.h>
#import <QCAR/TrackerManager.h>
#import <QCAR/ObjectTracker.h>
#import <QCAR/Trackable.h>
#import <QCAR/ImageTarget.h>
#import <QCAR/TargetFinder.h>
#import <QCAR/CameraDevice.h>
#import <Orchextra/NSBundle+ORCBundle.h>
#import <Orchextra/ORCThemeSdk.h>
#import <Orchextra/ORCVuforiaConfig.h>
#import <Orchextra/ORCLog.h>

#import "VFConfigurationInteractor.h"

@interface ORCCloudRecoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ARViewPlaceholder;
@property (strong, nonatomic) VFConfigurationInteractor *interactor;
@property (strong, nonatomic) ORCThemeSdk *theme;
@property (strong, nonatomic) ORCVuforiaConfig *vuforiaKeys;

@property (strong, nonatomic) NSString *imageUniqueId;

@end

@implementation ORCCloudRecoViewController

@synthesize tapGestureRecognizer, vapp, eaglView;


- (CGRect)getCurrentARViewFrame
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect viewFrame = screenBounds;
    
    // If this device has a retina display, scale the view bounds
    // for the AR (OpenGL) view
    if (YES == vapp.isRetinaDisplay) {
        viewFrame.size.width *= 2.0;
        viewFrame.size.height *= 2.0;
    }
    return viewFrame;
}

- (BOOL) isVisualSearchOn {
    return isVisualSearchOn;
}

- (void) setVisualSearchOn:(BOOL) isOn {
    isVisualSearchOn = isOn;
}

- (void)loadView
{
    
    if (self.ARViewPlaceholder != nil) {
        [self.ARViewPlaceholder removeFromSuperview];
        self.ARViewPlaceholder = nil;
    }
    
    scanningMode = YES;
    isVisualSearchOn = NO;
    
    extendedTrackingEnabled = NO;
    continuousAutofocusEnabled = YES;
    flashEnabled = NO;
    frontCameraEnabled = NO;
    
    self.interactor = [[VFConfigurationInteractor alloc] init];
    self.theme = [self.interactor themeSDK];
    self.vuforiaKeys = [self.interactor vuforiaCredentials];
    vapp = [[VuforiaApplicationSession alloc] initWithDelegate:self];
    
    CGRect viewFrame = [self getCurrentARViewFrame];
    
    eaglView = [[ORCCloudRecoEAGLView alloc] initWithFrame:viewFrame appSession:vapp viewController:self];
    [self setView:eaglView];

    // a single tap will trigger a single autofocus operation
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autofocus:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissARViewController)
                                                 name:@"kDismissARViewController"
                                               object:nil];
    
    // we use the iOS notification to pause/resume the AR when the application goes (or come back from) background
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(pauseAR)
     name:UIApplicationWillResignActiveNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(resumeAR)
     name:UIApplicationDidBecomeActiveNotification
     object:nil];
    
    // initialize AR
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [vapp initAR:QCAR::GL_20 orientation:orientation];

    // show loading animation while AR is being initialized
    [self showLoadingAnimation];
}

- (void) pauseAR {
    NSError * error = nil;
    if (![vapp pauseAR:&error]) {
        NSLog(@"Error pausing AR:%@", [error description]);
    }
}

- (void) resumeAR {
    NSError * error = nil;
    if(! [vapp resumeAR:&error]) {
        NSLog(@"Error resuming AR:%@", [error description]);
    }
    // on resume, we reset the flash
    QCAR::CameraDevice::getInstance().setFlashTorchMode(false);
    flashEnabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showingMenu = NO;
    
    self.title = ORCLocalizedBundle(@"Vuforia", nil, nil);
    
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    // last error seen - used to avoid seeing twice the same error in the error dialog box
    lastErrorCode = 99;
}

- (void)viewWillDisappear:(BOOL)animated
{
    // on iOS 7, viewWillDisappear may be called when the menu is shown
    // but we don't want to stop the AR view in that case
    if (self.showingMenu) {
        return;
    }
    
    [vapp stopAR:nil];
    
    // Be a good OpenGL ES citizen: now that QCAR is paused and the render
    // thread is not executing, inform the root view controller that the
    // EAGLView should finish any OpenGL ES commands
    [self finishOpenGLESCommands];
    
    // REMOVE: DEPENDENCY WITH APP DELEGATE
//    id appDelegate = [[UIApplication sharedApplication] delegate];
//    appDelegate.glResourceHandler = nil;
//    
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)finishOpenGLESCommands
{
    // Called in response to applicationWillResignActive.  Inform the EAGLView
    [eaglView finishOpenGLESCommands];
}

- (void)freeOpenGLESResources
{
    // Called in response to applicationDidEnterBackground.  Inform the EAGLView
    [eaglView freeOpenGLESResources];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showUIAlertFromErrorCode:(int)code
{
    if (lastErrorCode == code)
    {
        // we don't want to show twice the same error
        return;
    }
    lastErrorCode = code;
    
    NSString *title = nil;
    NSString *message = nil;
    
    if (code == QCAR::TargetFinder::UPDATE_ERROR_NO_NETWORK_CONNECTION)
    {
        title = ORCLocalizedBundle(@"UPDATE_ERROR_NO_NETWORK_CONNECTION_TITLE", nil, nil);
        message = ORCLocalizedBundle(@"UPDATE_ERROR_NO_NETWORK_CONNECTION_DESC", nil, nil);
    }
    else if (code == QCAR::TargetFinder::UPDATE_ERROR_REQUEST_TIMEOUT)
    {
        title = ORCLocalizedBundle(@"UPDATE_ERROR_REQUEST_TIMEOUT_TITLE", nil, nil);
        message = ORCLocalizedBundle(@"UPDATE_ERROR_REQUEST_TIMEOUT_DESC", nil, nil);
    }
    else if (code == QCAR::TargetFinder::UPDATE_ERROR_SERVICE_NOT_AVAILABLE)
    {
        title = ORCLocalizedBundle(@"UPDATE_ERROR_SERVICE_NOT_AVAILABLE_TITLE", nil, nil);
        message = ORCLocalizedBundle(@"UPDATE_ERROR_SERVICE_NOT_AVAILABLE_DESC", nil, nil);
    }
    else if (code == QCAR::TargetFinder::UPDATE_ERROR_UPDATE_SDK)
    {
        title = ORCLocalizedBundle(@"UPDATE_ERROR_UPDATE_SDK_TITLE", nil, nil);
        message = ORCLocalizedBundle(@"UPDATE_ERROR_UPDATE_SDK_DESC", nil, nil);
    }
    else if (code == QCAR::TargetFinder::UPDATE_ERROR_TIMESTAMP_OUT_OF_RANGE)
    {
        title = ORCLocalizedBundle(@"UPDATE_ERROR_TIMESTAMP_OUT_OF_RANGE_TITLE", nil, nil);
        message = ORCLocalizedBundle(@"UPDATE_ERROR_TIMESTAMP_OUT_OF_RANGE_DESC", nil, nil);
    }
    else if (code == QCAR::TargetFinder::UPDATE_ERROR_AUTHORIZATION_FAILED)
    {
        title = ORCLocalizedBundle(@"UPDATE_ERROR_AUTHORIZATION_FAILED_TITLE", nil, nil);
        message = ORCLocalizedBundle(@"UPDATE_ERROR_AUTHORIZATION_FAILED_DESC", nil, nil);
    }
    else if (code == QCAR::TargetFinder::UPDATE_ERROR_PROJECT_SUSPENDED)
    {
        title = ORCLocalizedBundle(@"UPDATE_ERROR_PROJECT_SUSPENDED_TITLE", nil, nil);
        message = ORCLocalizedBundle(@"UPDATE_ERROR_PROJECT_SUSPENDED_DESC", nil, nil);
    }
    else if (code == QCAR::TargetFinder::UPDATE_ERROR_BAD_FRAME_QUALITY)
    {
        title = ORCLocalizedBundle(@"UPDATE_ERROR_BAD_FRAME_QUALITY_TITLE", nil, nil);
        message = ORCLocalizedBundle(@"UPDATE_ERROR_BAD_FRAME_QUALITY_DESC", nil, nil);
    }
    else
    {
        title = @"Unknown error";
        message = [NSString stringWithFormat:@"An unknown error has occurred (Code %d)", code];
    }
    
    //  Call the UIAlert on the main thread to avoid undesired behaviors
    dispatch_async( dispatch_get_main_queue(), ^{
        if (title && message)
        {
            UIAlertView *anAlertView = [[UIAlertView alloc] initWithTitle:title
                                                                  message:message
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
            [anAlertView show];
        }
    });
}


#pragma mark - loading animation

- (void) showLoadingAnimation {
    CGRect indicatorBounds;
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    int smallerBoundsSize = MIN(mainBounds.size.width, mainBounds.size.height);
    int largerBoundsSize = MAX(mainBounds.size.width, mainBounds.size.height);
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown ) {
        indicatorBounds = CGRectMake(smallerBoundsSize / 2 - 12,
                                     largerBoundsSize / 2 - 12, 24, 24);
    }
    else {
        indicatorBounds = CGRectMake(largerBoundsSize / 2 - 12,
                                     smallerBoundsSize / 2 - 12, 24, 24);
    }
    
    UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithFrame:indicatorBounds];
    
    loadingIndicator.tag  = 1;
    loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [eaglView addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
}

- (void) hideLoadingAnimation {
    UIActivityIndicatorView *loadingIndicator = (UIActivityIndicatorView *)[eaglView viewWithTag:1];
    [loadingIndicator removeFromSuperview];
}


#pragma mark - SampleApplicationControl

- (bool) doInitTrackers {
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::Tracker* trackerBase = trackerManager.initTracker(QCAR::ObjectTracker::getClassType());
    // Set the visual search credentials:
    QCAR::TargetFinder* targetFinder = static_cast<QCAR::ObjectTracker*>(trackerBase)->getTargetFinder();
    if (targetFinder == NULL)
    {
        NSLog(@"Failed to get target finder.");
        return NO;
    }
    
    NSLog(@"Successfully initialized ObjectTracker.");
    return YES;
}

- (bool) doLoadTrackersData {
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker* objectTracker = static_cast<QCAR::ObjectTracker*>(trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    if (objectTracker == NULL)
    {
        NSLog(@">doLoadTrackersData>Failed to load tracking data set because the ImageTracker has not been initialized.");
        return NO;
        
    }
    
    // Initialize visual search:
    QCAR::TargetFinder* targetFinder = objectTracker->getTargetFinder();
    if (targetFinder == NULL)
    {
        NSLog(@">doLoadTrackersData>Failed to get target finder.");
        return NO;
    }
    
    NSDate *start = [NSDate date];
    
    const char *kAccessKey = [self.vuforiaKeys.accessKey cStringUsingEncoding:NSUTF8StringEncoding];
    const char *kSecretKey = [self.vuforiaKeys.secretKey cStringUsingEncoding:NSUTF8StringEncoding];
    
    // Start initialization:
    if (targetFinder->startInit(kAccessKey, kSecretKey))
    {
        targetFinder->waitUntilInitFinished();
        
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start];
        
        NSLog(@"waitUntilInitFinished Execution Time: %lf", executionTime);
    }
    
    int resultCode = targetFinder->getInitState();
    if ( resultCode != QCAR::TargetFinder::INIT_SUCCESS)
    {
        NSLog(@">doLoadTrackersData>Failed to initialize target finder.");
        if (resultCode == QCAR::TargetFinder::INIT_ERROR_NO_NETWORK_CONNECTION) {
            NSLog(@"CloudReco error:QCAR::TargetFinder::INIT_ERROR_NO_NETWORK_CONNECTION");
        } else if (resultCode == QCAR::TargetFinder::INIT_ERROR_SERVICE_NOT_AVAILABLE) {
            NSLog(@"CloudReco error:QCAR::TargetFinder::INIT_ERROR_SERVICE_NOT_AVAILABLE");
        } else {
            NSLog(@"CloudReco error:%d", resultCode);
        }
        
        int initErrorCode;
        if(resultCode == QCAR::TargetFinder::INIT_ERROR_NO_NETWORK_CONNECTION)
        {
            initErrorCode = QCAR::TargetFinder::UPDATE_ERROR_NO_NETWORK_CONNECTION;
        }
        else
        {
            initErrorCode = QCAR::TargetFinder::UPDATE_ERROR_SERVICE_NOT_AVAILABLE;
        }
        [self showUIAlertFromErrorCode: initErrorCode];
        return NO;
    } else {
        NSLog(@">doLoadTrackersData>target finder initialized");
    }
    
    return YES;
}

- (bool) doStartTrackers {
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    
    QCAR::ObjectTracker* objectTracker = static_cast<QCAR::ObjectTracker*>(
                                                                           trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    if (objectTracker == 0) {
        NSLog(@"Failed to start Object Tracker, as it is null.");
        return NO;
    }
    objectTracker->start();
    
    if (scanningMode)
    {
        QCAR::TargetFinder* targetFinder = objectTracker->getTargetFinder();
        if (targetFinder != 0) {
            isVisualSearchOn = targetFinder->startRecognition();
        }
    }
    return YES;
}

- (void) onInitARDone:(NSError *)initError {

    dispatch_async( dispatch_get_main_queue(), ^{
        UIActivityIndicatorView *loadingIndicator = (UIActivityIndicatorView *)[eaglView viewWithTag:1];
        [loadingIndicator removeFromSuperview];
    });
    
    if (initError == nil) {
        NSError * error = nil;
        [vapp startAR:QCAR::CameraDevice::CAMERA_BACK error:&error];
        
        continuousAutofocusEnabled = QCAR::CameraDevice::getInstance().setFocusMode(QCAR::CameraDevice::FOCUS_MODE_CONTINUOUSAUTO);
        
    } else {
        NSLog(@"Error initializing AR:%@", [initError description]);
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[initError localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        });
    }
}

- (bool) doStopTrackers {
    // Stop the tracker:
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker* objectTracker = static_cast<QCAR::ObjectTracker*>(
                                                                           trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    if(objectTracker != 0) {
        objectTracker->stop();
        
        // Stop cloud based recognition:
        QCAR::TargetFinder* targetFinder = objectTracker->getTargetFinder();
        if (targetFinder != 0) {
            isVisualSearchOn = !targetFinder->stop();
        }
    }
    return YES;
}

- (bool) doUnloadTrackersData {
    // Get the image tracker:
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker* objectTracker = static_cast<QCAR::ObjectTracker*>(trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    
    if (objectTracker == NULL)
    {
        NSLog(@"Failed to unload tracking data set because the ObjectTracker has not been initialized.");
        return NO;
    }
    
    // Deinitialize visual search:
    QCAR::TargetFinder* finder = objectTracker->getTargetFinder();
    finder->deinit();
    return YES;
}

- (bool) doDeinitTrackers {
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kDismissARViewController" object:nil];
}

- (void)dismissARViewController
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

// update from the QCAR
- (void) onQCARUpdate: (QCAR::State *) state {
    // Get the tracker manager:
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    
    // Get the image tracker:
    QCAR::ObjectTracker* objectTracker = static_cast<QCAR::ObjectTracker*>(trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    
    // Get the target finder:
    QCAR::TargetFinder* finder = objectTracker->getTargetFinder();
    
    
    const QCAR::TargetSearchResult* searchresult = finder->getResult(0);
    const char* value = nil;
    
    if (searchresult)
    {
        value = searchresult->getUniqueTargetId();
        
        NSString *const resultConstString = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
        self.imageUniqueId = resultConstString;
    }

    UIColor *color = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0];
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    
    CGFloat red = components[0];
    CGFloat blue = components[1];
    CGFloat green = components[2];
    
    finder->setUIPointColor(red, blue, green);


    // Check if there are new results available:
    const int statusCode = finder->updateSearchResults();
    if (statusCode < 0)
    {

        if (statusCode == QCAR::TargetFinder::UPDATE_ERROR_NO_NETWORK_CONNECTION) {
            [self showUIAlertFromErrorCode:statusCode];
        }
    }
    else if (statusCode == QCAR::TargetFinder::UPDATE_RESULTS_AVAILABLE)
    {
        
        // Iterate through the new results:
        for (int i = 0; i < finder->getResultCount(); ++i)
        {
            const QCAR::TargetSearchResult* result = finder->getResult(i);
            
            // Check if this target is suitable for tracking:
            if (result->getTrackingRating() > 0)
            {
                // Create a new Trackable from the result:
                QCAR::Trackable* newTrackable = finder->enableTracking(*result);
                if (newTrackable != 0)
                {
                    if (extendedTrackingEnabled) {
                        newTrackable->startExtendedTracking();
                    }
                }
                else
                {
                    NSLog(@"Failed to create new trackable.");
                }
            }
        }
    }
    
}

- (void) toggleVisualSearch {
    [self toggleVisualSearch:isVisualSearchOn];
}

- (void) toggleVisualSearch:(BOOL)visualSearchOn
{
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker* objectTracker = static_cast<QCAR::ObjectTracker*>(trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    
    if (objectTracker == 0) {
        NSLog(@"Failed to toggle Visual Search, as Object Tracker is null.");
        return;
    }
    
    QCAR::TargetFinder* targetFinder = objectTracker->getTargetFinder();
    if (visualSearchOn == NO)
    {
//        NSLog(@"Starting target finder");
        targetFinder->startRecognition();
        isVisualSearchOn = YES;
    }
    else
    {
//        NSLog(@"Stopping target finder");
        targetFinder->stop();
        isVisualSearchOn = NO;
    }
}


- (void)autofocus:(UITapGestureRecognizer *)sender
{
    [self performSelector:@selector(cameraPerformAutoFocus) withObject:nil afterDelay:.4];
}

- (void)cameraPerformAutoFocus
{
    QCAR::CameraDevice::getInstance().setFocusMode(QCAR::CameraDevice::FOCUS_MODE_TRIGGERAUTO);
}

- (void) setOffTargetTracking:(BOOL) isActive {
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker* objectTracker = static_cast<QCAR::ObjectTracker*>(trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    
    if (objectTracker == 0) {
        NSLog(@"Failed to enable Extended Tracking, as the Object Tracker is null.");
        return;
    }
    
    QCAR::TargetFinder* targetFinder = objectTracker->getTargetFinder();
    int nbTargets = targetFinder->getNumImageTargets();
    for(int idx = 0; idx < nbTargets ; idx++) {
        QCAR::ImageTarget * it = targetFinder->getImageTarget(idx);
        if (it != NULL) {
            if (isActive) {
                it->startExtendedTracking();
            } else {
                it->stopExtendedTracking();
            }
        }
    }
}


#pragma mark - menu delegate protocol implementation

- (BOOL) menuProcess:(NSString *)itemName value:(BOOL)value
{
    if ([@"Extended Tracking" isEqualToString:itemName]) {
        extendedTrackingEnabled = value;
        [self setOffTargetTracking:extendedTrackingEnabled];
        return YES;
    }
    return NO;
}

- (void) menuDidExit
{
    self.showingMenu = NO;
}

#pragma mark - 

- (NSString *)getUniqueIDForImageRecognized
{
    return self.imageUniqueId;
}

@end

#endif
