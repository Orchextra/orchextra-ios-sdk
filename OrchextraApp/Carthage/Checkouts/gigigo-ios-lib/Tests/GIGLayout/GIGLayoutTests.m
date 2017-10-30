//
//  GIGLayoutTests.m
//  layout
//
//  Created by Sergio Baró on 06/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GIGLayout.h"


@interface GIGLayoutTests : XCTestCase

@end

@implementation GIGLayoutTests

#pragma mark - Tests (Basic)

- (void)testLayoutViewsDictionary
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    NSDictionary *views = GIGViews(view);
    XCTAssertTrue(views[@"view"] == view, @"%@", views[@"view"]);
}

- (void)testLayoutViewsDictionaryTwoViews
{
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    NSDictionary *views = GIGViews(view1, view2);
    XCTAssertTrue(views[@"view1"] == view1, @"%@", views[@"view1"]);
    XCTAssertTrue(views[@"view2"] == view2, @"%@", views[@"view2"]);
}

- (void)testLayoutSize
{
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    gig_autoresize(parent, NO);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    gig_autoresize(view, NO);
    gig_constrain_size(view, CGSizeMake(100, 200));
    [parent addSubview:view];
    
    CGSize size = gig_layout_size(view);
    
    XCTAssertTrue(size.width == 100, @"%d", (int)size.width);
    XCTAssertTrue(size.height == 200, @"%d", (int)size.height);
    
    [parent layoutIfNeeded];
    
    XCTAssertTrue(view.frame.size.width == 100, @"%d", (int)view.frame.size.width);
    XCTAssertTrue(view.frame.size.height == 200, @"%d", (int)view.frame.size.height);
}

#pragma mark - Tests (Fit)

- (void)testLayoutFit
{
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    gig_autoresize(parent, NO);
    UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    gig_autoresize(subview, NO);
    [parent addSubview:subview];
    
    gig_layout_fit(subview);
    
    XCTAssertFalse(CGSizeEqualToSize(parent.frame.size, subview.frame.size));
    [parent layoutIfNeeded];
    XCTAssertTrue(CGSizeEqualToSize(parent.frame.size, subview.frame.size));
}

#pragma mark - Tests (Center)

- (void)testLayoutCenterHorizontal
{
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    gig_autoresize(parent, NO);
    gig_constrain_size(parent, CGSizeMake(100, 200));
    
    UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    gig_autoresize(subview, NO);
    [parent addSubview:subview];
    
    gig_layout_center_horizontal(subview, 0);
    
    XCTAssertFalse(subview.center.x == parent.center.x);
    [parent layoutIfNeeded];
    XCTAssertTrue(subview.center.x == parent.center.x);
}

- (void)testLayoutCenterVertical
{
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    gig_autoresize(parent, NO);
    gig_constrain_size(parent, CGSizeMake(100, 200));
    
    UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    gig_autoresize(subview, NO);
    [parent addSubview:subview];
    
    gig_layout_center_vertical(subview, 0);
    
    XCTAssertFalse(subview.center.y == parent.center.y);
    [parent layoutIfNeeded];
    XCTAssertTrue(subview.center.y == parent.center.y, @"%d <> %d", (int)subview.center.y, (int)parent.center.y);
}

- (void)testLayoutCenter
{
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    gig_autoresize(parent, NO);
    gig_constrain_size(parent, CGSizeMake(100, 200));
    
    UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    gig_autoresize(subview, NO);
    [parent addSubview:subview];
    
    gig_layout_center(subview);
    
    XCTAssertFalse(CGPointEqualToPoint(parent.center, subview.center));
    [parent layoutIfNeeded];
    XCTAssertTrue(CGPointEqualToPoint(parent.center, subview.center));
}

- (void)testLayoutCenterHorizontalView
{
    UIView *parent = [self viewWithFrame:CGRectMake(0, 0, 400, 400)];
    UIView *centerView = [self viewWithFrame:CGRectMake(0, 0, 50, 50)];
    [parent addSubview:centerView];
    gig_layout_top(centerView, 10);
    gig_layout_left(centerView, 10);
    UIView *view = [self viewWithFrame:CGRectMake(50, 50, 50, 50)];
    [parent addSubview:view];
    gig_layout_top(view, 60);
    
    gig_layout_center_horizontal_view(view, centerView, 0);
    
    XCTAssertFalse(centerView.center.x == view.center.x, @"%d", (int)view.center.x);
    [parent layoutIfNeeded];
    XCTAssertTrue(centerView.center.x == view.center.x, @"%d", (int)view.center.x);
}

- (void)testLayoutCenterVerticalView
{
    UIView *parent = [self viewWithFrame:CGRectMake(0, 0, 400, 400)];
    UIView *centerView = [self viewWithFrame:CGRectMake(0, 0, 50, 50)];
    [parent addSubview:centerView];
    gig_layout_top(centerView, 10);
    gig_layout_left(centerView, 10);
    UIView *view = [self viewWithFrame:CGRectMake(50, 50, 50, 50)];
    [parent addSubview:view];
    gig_layout_left(view, 60);
    
    gig_layout_center_vertical_view(view, centerView, 0);
    
    XCTAssertFalse(centerView.center.y == view.center.y, @"%d", (int)view.center.y);
    [parent layoutIfNeeded];
    XCTAssertTrue(centerView.center.y == view.center.y, @"%d", (int)view.center.y);
}

- (void)testLayoutCenterView
{
    UIView *parent = [self viewWithFrame:CGRectMake(0, 0, 400, 400)];
    UIView *centerView = [self viewWithFrame:CGRectMake(0, 0, 100, 100)];
    [parent addSubview:centerView];
    gig_layout_center(centerView);
    UIView *view = [self viewWithFrame:CGRectMake(10, 10, 50, 50)];
    [parent addSubview:view];
    
    gig_layout_center_view(view, centerView);
    
    XCTAssertFalse(CGPointEqualToPoint(view.center, centerView.center));
    [parent layoutIfNeeded];
    XCTAssertTrue(CGPointEqualToPoint(view.center, centerView.center));
}

#pragma mark - Tests (Sides)

- (void)testLayoutTop
{
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    gig_autoresize(parent, NO);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    gig_autoresize(view, NO);
    gig_constrain_size(view, CGSizeMake(50, 50));
    [parent addSubview:view];
    
    gig_layout_top(view, 10);
    
    XCTAssertFalse(view.frame.origin.y == 10, @"%d", (int)view.frame.origin.y);
    [parent layoutIfNeeded];
    XCTAssertTrue(view.frame.origin.y == 10, @"%d", (int)view.frame.origin.y);
}

- (void)testLayoutBottom
{
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    gig_autoresize(parent, NO);
    gig_constrain_size(parent, parent.frame.size);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    gig_autoresize(view, NO);
    gig_constrain_size(view, CGSizeMake(50, 50));
    [parent addSubview:view];
    
    gig_layout_bottom(view, 10);
    
    CGFloat expectedHeight = parent.frame.size.height - 50 - 10;
    XCTAssertFalse(view.frame.origin.y == expectedHeight, @"%d", (int)view.frame.origin.y);
    [parent layoutIfNeeded];
    XCTAssertTrue(parent.frame.size.height != 0);
    XCTAssertTrue(view.frame.origin.y == expectedHeight, @"%d, expected: %d", (int)view.frame.origin.y, (int)expectedHeight);
}

- (void)testLayoutLeft
{
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    gig_autoresize(parent, NO);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    gig_autoresize(view, NO);
    gig_constrain_size(view, CGSizeMake(50, 50));
    [parent addSubview:view];
    
    gig_layout_left(view, 10);
    
    XCTAssertFalse(view.frame.origin.x == 10, @"%d", (int)view.frame.origin.x);
    [parent layoutIfNeeded];
    XCTAssertTrue(view.frame.origin.x == 10, @"%d", (int)view.frame.origin.x);
}

- (void)testLayoutRight
{
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    gig_autoresize(parent, NO);
    gig_constrain_size(parent, parent.frame.size);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    gig_autoresize(view, NO);
    gig_constrain_size(view, CGSizeMake(50, 50));
    [parent addSubview:view];
    
    gig_layout_right(view, 10);
    
    CGFloat expectedX = parent.frame.size.width - 50 - 10;
    XCTAssertFalse(view.frame.origin.x == expectedX, @"%d", (int)view.frame.origin.x);
    [parent layoutIfNeeded];
    XCTAssertTrue(view.frame.origin.x == expectedX, @"%d, expected: %d", (int)view.frame.origin.x, (int)expectedX);
}

- (void)testLayoutBelowView
{
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 200)];
    gig_autoresize(parent, NO);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    gig_autoresize(view, NO);
    gig_constrain_size(view, CGSizeMake(50, 50));
    [parent addSubview:view];
    UIView *aboveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    gig_autoresize(aboveView, NO);
    gig_constrain_size(aboveView, CGSizeMake(50, 50));
    [parent addSubview:aboveView];
    gig_layout_top(aboveView, 10);
    
    gig_layout_below(view, aboveView, 10);
    
    CGFloat expectedY = 10 + 50 + 10;
    XCTAssertFalse(view.frame.origin.y == expectedY, @"%d", (int)view.frame.origin.y);
    [parent layoutIfNeeded];
    XCTAssertTrue(view.frame.origin.y == expectedY, @"%d", (int)view.frame.origin.y);
}

- (void)testLayoutAboveView
{
    UIView *parent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 200)];
    gig_autoresize(parent, NO);
    gig_constrain_size(parent, parent.frame.size);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    gig_autoresize(view, NO);
    gig_constrain_size(view, CGSizeMake(50, 50));
    [parent addSubview:view];
    UIView *belowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    gig_autoresize(belowView, NO);
    gig_constrain_size(belowView, CGSizeMake(50, 50));
    [parent addSubview:belowView];
    gig_layout_bottom(belowView, 10);
    
    gig_layout_above(view, belowView, 10);
    
    CGFloat expectedY = 200 - 10 - 50 - 10 - 50;
    XCTAssertFalse(view.frame.origin.y == expectedY, @"%d, expected: %d", (int)view.frame.origin.y, (int)expectedY);
    [parent layoutIfNeeded];
    XCTAssertTrue(view.frame.origin.y == expectedY, @"%d, expected: %d", (int)view.frame.origin.y, (int)expectedY);
}

- (void)testLayoutLeftView
{
    UIView *parent = [self viewWithFrame:CGRectMake(0, 0, 400, 200)];
    UIView *leftView = [self viewWithFrame:CGRectMake(0, 0, 50, 50)];
    UIView *rightView = [self viewWithFrame:CGRectMake(0, 0, 50, 50)];
    [parent addSubview:leftView];
    [parent addSubview:rightView];
    gig_layout_right(rightView, 10);
    gig_layout_left_view(leftView, rightView, 10);
    
    CGFloat expectedX = 400 - 10 - 50 - 10 - 50;
    XCTAssertFalse(leftView.frame.origin.x == expectedX, @"%d", (int)leftView.frame.origin.x);
    [parent layoutIfNeeded];
    XCTAssertTrue(leftView.frame.origin.x == expectedX, @"%d", (int)leftView.frame.origin.x);
}

- (void)testLayoutRightView
{
    UIView *parent = [self viewWithFrame:CGRectMake(0, 0, 400, 200)];
    UIView *leftView = [self viewWithFrame:CGRectMake(0, 0, 50, 50)];
    UIView *rightView = [self viewWithFrame:CGRectMake(0, 0, 50, 50)];
    [parent addSubview:leftView];
    [parent addSubview:rightView];
    gig_layout_left(leftView, 10);
    gig_layout_right_view(rightView, leftView, 10);
    
    CGFloat expectedX = 10 + 50 + 10;
    XCTAssertFalse(rightView.frame.origin.x == expectedX, @"%d", (int)rightView.frame.origin.x);
    [parent layoutIfNeeded];
    XCTAssertTrue(rightView.frame.origin.x == expectedX, @"%d", (int)rightView.frame.origin.x);
}

#pragma mark - HELPERS

- (UIView *)viewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    gig_autoresize(view, NO);
    gig_constrain_size(view, frame.size);
    
    return view;
}

@end
