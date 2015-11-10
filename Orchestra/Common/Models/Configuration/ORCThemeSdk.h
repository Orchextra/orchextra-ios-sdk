//
//  ORCConfigData.h
//  Orchestra
//
//  Created by Judith Medina on 8/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ORCThemeSdk : NSObject <NSCoding>

@property (strong, nonatomic) UIColor *primaryColor;
@property (strong, nonatomic) UIColor *secondaryColor;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
