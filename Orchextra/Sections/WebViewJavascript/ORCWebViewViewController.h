//
//  ORCWebViewViewController.h
//  Orchextra
//
//  Created by Judith Medina on 15/3/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@class ORCActionManager;

@interface ORCWebViewViewController : UIViewController <WKScriptMessageHandler>

- (instancetype)initWithActionManager:(ORCActionManager *)actionManager;

- (void)startWithURLString:(NSString *)urlString;
- (void)reloadURLString:(NSString *)urlString;

@end
