//
//  ORCWebViewPresenter.m
//  Orchextra
//
//  Created by Judith Medina on 15/3/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCWebViewPresenter.h"
#import "ORCAction.h"

@interface ORCWebViewPresenter()

@property (nonatomic, strong) ORCActionManager *actionManager;
@property (nonatomic, strong) NSURL *currentURL;

@end

@implementation ORCWebViewPresenter

- (instancetype)initWithActionManager:(ORCActionManager *)actionManager
{
    self = [super init];
    
    if (self)
    {
        _actionManager = actionManager;
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)viewIsReady
{
    if (self.currentURL)
    {
        [self loadURLinWebView];
    }
}

- (void)prepareURLWithString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    self.currentURL = url;
}

- (void)reloadURLWithStringFromJS:(NSString *)urlString
{
    [self prepareURLWithString:urlString];
    [self loadURLinWebView];
}

- (void)jsInvokeOpenScanner
{
    ORCAction *barcodeAction = [[ORCAction alloc] initWithType:ORCActionOpenScannerID];
    barcodeAction.urlString = ORCSchemeScanner;
    [self.actionManager launchAction:barcodeAction];
}

- (void)jsInvokeOpenImageRecognition
{
    ORCAction *imageRecognitionAction = [[ORCAction alloc] initWithType:ORCActionVuforiaID];
    imageRecognitionAction.urlString = ORCSchemeImageRecognition;
    [self.actionManager launchAction:imageRecognitionAction];
}

- (void)urlHasBeenLoadedSuccessfully:(BOOL)success
{
    [self.viewController stopSpinner];

    if (success)
    {
        
    }
    else
    {
        
    }
}

#pragma mark - PRIVATE

- (void)loadURLinWebView
{
    [self.viewController showSpinner];
    [self.viewController loadURLInCurrentWebView:self.currentURL];
}

@end
