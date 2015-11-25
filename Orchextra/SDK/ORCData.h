//
//  ORCDataSource.h
//  Orchestra
//
//  Created by Judith Medina on 10/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrchextraOutputInterface.h"

@interface ORCData : NSObject
<OrchextraOutputInterface>

- (void)setEnvironment:(NSString *)environment;

@end
