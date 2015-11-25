/*===============================================================================
Copyright (c) 2012-2015 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.
===============================================================================*/

#import <UIKit/UIKit.h>
#import "ORCCloudRecoEAGLView.h"
#import "VuforiaApplicationSession.h"
#import <QCAR/DataSet.h>

@interface ORCCloudRecoViewController : UIViewController <VuforiaApplicationControl, UIAlertViewDelegate> {
    
    BOOL scanningMode;
    BOOL isVisualSearchOn;
    
    int lastErrorCode;
    
    // menu options
    BOOL extendedTrackingEnabled;
    BOOL continuousAutofocusEnabled;
    BOOL flashEnabled;
    BOOL frontCameraEnabled;
}

@property (nonatomic, strong) ORCCloudRecoEAGLView* eaglView;
@property (nonatomic, strong) UITapGestureRecognizer * tapGestureRecognizer;
@property (nonatomic, strong) VuforiaApplicationSession * vapp;

@property (nonatomic, readwrite) BOOL showingMenu;

- (BOOL) isVisualSearchOn;
- (void) toggleVisualSearch;
- (NSString *)getUniqueIDForImageRecognized;

@end
