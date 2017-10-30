//
//  GIGLayoutGridVerticalTests.m
//  giglibrary
//
//  Created by Judith Medina on 14/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGLayoutGridVertical.h"


@interface GIGLayoutGridVerticalTests : XCTestCase

@property (strong, nonatomic) GIGLayoutGridVertical *gridVertical;
@property (strong, nonatomic) NSArray *subviews;

@end

@implementation GIGLayoutGridVerticalTests

- (void)setUp
{
    [super setUp];
    
    _gridVertical = [[GIGLayoutGridVertical alloc] init];
    
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++)
    {
        UIView *view = [self createHelperViewWithHeight:100 * (i + 1)];
        [views addObject:view];
    }
    
    _subviews = views;
}

- (void)tearDown
{
    [super tearDown];
    
    _gridVertical = nil;
    _subviews = nil;
}

- (void)test_grid_vertical_views
{
    [self.gridVertical fitViewsVertical:self.subviews];
    
    NSUInteger numSubviews = self.gridVertical.container.subviews.count;
    XCTAssertTrue(numSubviews == 3, @"Subviews: %lu", (unsigned long)numSubviews);
    
    CGFloat expectedHeight = 100 + 200 + 300;
    XCTAssertTrue(expectedHeight == self.gridVertical.contentSize.height, @"%f", self.gridVertical.contentSize.height);
}

- (void)test_grid_vertical_addsubview_to_grid
{
    [self.gridVertical fitViewsVertical:self.subviews];

}


#pragma mark - Helper

- (UIView *)createHelperViewWithHeight:(CGFloat)height
{
    UIView *view = [[UIView alloc] init];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view setBackgroundColor:[UIColor yellowColor]];
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    
    NSLayoutConstraint *Hconstraint = [NSLayoutConstraint
                                       constraintWithItem:view
                                       attribute:NSLayoutAttributeWidth
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:nil
                                       attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1.0
                                       constant:CGRectGetWidth([[UIScreen mainScreen] bounds])];
    
    NSLayoutConstraint *Vconstraint = [NSLayoutConstraint
                                       constraintWithItem:view
                                       attribute:NSLayoutAttributeHeight
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:nil
                                       attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1.0
                                       constant:height];
    
    [view addConstraints:@[Hconstraint, Vconstraint]];
    
    return view;
}


@end
