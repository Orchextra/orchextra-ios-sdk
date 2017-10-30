//
//  GIGLayoutGrid.h
//  AutoLayoutLibrary
//
//  Created by Judith Medina on 13/4/15.
//  Copyright (c) 2015 Judith Medina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GIGLayoutGridVertical : UIScrollView

@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) NSArray *views;

- (void)fitViewsVertical:(NSArray *)subviews;
- (void)addSubviewGrid:(UIView *)view;
- (void)insertSubviewGrid:(UIView *)view aboveSubview:(UIView *)aboveSubview;
- (void)insertSubviewGrid:(UIView *)view bellowSubview:(UIView *)bellowSubview;
- (void)insertSubviewGrid:(UIView *)view atIndex:(NSInteger)index;

@end
