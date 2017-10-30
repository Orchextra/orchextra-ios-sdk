//
//  GIGLayoutCenter.h
//  layout
//
//  Created by Sergio Baró on 06/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#ifndef layout_GIGLayoutCenter_h
#define layout_GIGLayoutCenter_h


__unused static NSLayoutConstraint* gig_layout_center_horizontal(UIView *view, CGFloat margin)
{
    NSLayoutConstraint *constraint = gig_constraint(view, NSLayoutAttributeCenterX, NSLayoutRelationEqual, view.superview, NSLayoutAttributeCenterX, margin);
    [view.superview addConstraint:constraint];
    
    return constraint;
}

__unused static NSLayoutConstraint* gig_layout_center_horizontal_view(UIView *view, UIView *centerView, CGFloat margin)
{
    NSLayoutConstraint *constraint = gig_constraint(view, NSLayoutAttributeCenterX, NSLayoutRelationEqual, centerView, NSLayoutAttributeCenterX, margin);
    [view.superview addConstraint:constraint];

    return constraint;
}

__unused static NSLayoutConstraint* gig_layout_center_vertical(UIView *view, CGFloat margin)
{
    NSLayoutConstraint *constraint = gig_constraint(view, NSLayoutAttributeCenterY, NSLayoutRelationEqual, view.superview, NSLayoutAttributeCenterY, margin);
    [view.superview addConstraint:constraint];
    
    return constraint;
}


__unused static NSLayoutConstraint* gig_layout_center_vertical_view(UIView *view, UIView *centerView, CGFloat margin)
{
    NSLayoutConstraint *constraint = gig_constraint(view, NSLayoutAttributeCenterY, NSLayoutRelationEqual, centerView, NSLayoutAttributeCenterY, margin);
    [view.superview addConstraint:constraint];
    
    return constraint;
}

__unused static NSArray* gig_layout_center(UIView *view)
{
    NSLayoutConstraint *horizontal = gig_layout_center_horizontal(view, 0);
    NSLayoutConstraint *vertical = gig_layout_center_vertical(view, 0);
    
    return @[horizontal, vertical];
}

__unused static NSArray* gig_layout_center_view(UIView *view, UIView *centerView)
{
    NSLayoutConstraint *horizontal = gig_layout_center_horizontal_view(view, centerView, 0);
    NSLayoutConstraint *vertical = gig_layout_center_vertical_view(view, centerView, 0);
    
    return @[horizontal, vertical];
}


#endif
