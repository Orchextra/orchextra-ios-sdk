//
//  ORCVuforiaViewController.h
//  Orchestra
//
//  Created by Judith Medina on 8/10/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORCVuforiaPresenter.h"

@interface ORCVuforiaViewController : UIViewController
<ORCVuforiaInterface>

@property (strong, nonatomic) ORCVuforiaPresenter *presenter;


@end
