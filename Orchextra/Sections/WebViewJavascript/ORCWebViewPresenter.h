//
//  ORCWebViewPresenter.h
//  Orchextra
//
//  Created by Judith Medina on 15/3/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORCActionManager.h"

@protocol ORCWebViewInterface <NSObject>

- (void)loadURLInCurrentWebView:(NSURL *)url;
- (void)showSpinner;
- (void)stopSpinner;

@end

@interface ORCWebViewPresenter : NSObject

@property (nonatomic, strong) UIViewController<ORCWebViewInterface> *viewController;

- (instancetype)initWithActionManager:(ORCActionManager *)actionManager;

- (void)viewIsReady;
- (void)prepareURLWithString:(NSString *)urlString;
- (void)reloadURLWithStringFromJS:(NSString *)urlString;

- (void)jsInvokeOpenScanner;
- (void)jsInvokeOpenImageRecognition;
- (void)urlHasBeenLoadedSuccessfully:(BOOL)success;

@end
