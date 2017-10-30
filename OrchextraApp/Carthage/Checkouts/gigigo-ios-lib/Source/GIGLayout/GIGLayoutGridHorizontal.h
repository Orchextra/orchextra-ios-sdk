//
//  GIGLayoutGridHorizontal.h
//  AutoLayoutLibrary
//
//  Created by Judith Medina on 14/4/15.
//  Copyright (c) 2015 Judith Medina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GIGLayoutGridHorizontal : UIScrollView

@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) NSArray *views;

- (void)fitViewsHorizontal:(NSArray *)subviews;
- (void)addSubviewGrid:(UIView *)view;
- (void)insertSubviewGrid:(UIView *)view aboveSubview:(UIView *)aboveSubview;
- (void)insertSubviewGrid:(UIView *)view bellowSubview:(UIView *)bellowSubview;
- (void)insertSubviewGrid:(UIView *)view atIndex:(NSInteger)index;

@end
