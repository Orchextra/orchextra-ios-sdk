//
//  GIGLayoutSides.h
//  layout
//
//  Created by Sergio Baró on 06/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#ifndef layout_GIGLayoutSides_h
#define layout_GIGLayoutSides_h


__unused static NSLayoutConstraint* gig_layout_top(UIView *subview, CGFloat top)
{
    NSLayoutConstraint *constraint = gig_constraint_attribute_view(subview, subview.superview, NSLayoutAttributeTop, top);
    [subview.superview addConstraint:constraint];
    
    return constraint;
}

__unused static NSLayoutConstraint* gig_layout_bottom(UIView *subview, CGFloat bottom)
{
    NSLayoutConstraint *constraint = gig_constraint_attribute_view(subview, subview.superview, NSLayoutAttributeBottom, -bottom);
    [subview.superview addConstraint:constraint];
    
    return constraint;
}

__unused static NSLayoutConstraint* gig_layout_left(UIView *subview, CGFloat left)
{
    NSLayoutConstraint *constraint = gig_constraint_attribute_view(subview, subview.superview, NSLayoutAttributeLeft, left);
    [subview.superview addConstraint:constraint];
    
    return constraint;
}

__unused static NSLayoutConstraint* gig_layout_right(UIView *subview, CGFloat right)
{
    NSLayoutConstraint *constraint = gig_constraint_attribute_view(subview, subview.superview, NSLayoutAttributeRight, -right);
    [subview.superview addConstraint:constraint];
    
    return constraint;
}


__unused static NSLayoutConstraint* gig_layout_below(UIView *belowView, UIView *aboveView, CGFloat margin)
{
    NSLayoutConstraint *constraint = gig_constraint(belowView, NSLayoutAttributeTop, NSLayoutRelationEqual, aboveView, NSLayoutAttributeBottom, margin);
    [belowView.superview addConstraint:constraint];
    
    return constraint;
}

__unused static NSLayoutConstraint* gig_layout_above(UIView *aboveView, UIView *belowView, CGFloat margin)
{
    return gig_layout_below(belowView, aboveView, margin);
}

__unused static NSLayoutConstraint* gig_layout_left_view(UIView *leftView, UIView *rightView, CGFloat margin)
{
    NSLayoutConstraint *constraint = gig_constraint(leftView, NSLayoutAttributeRight, NSLayoutRelationEqual, rightView, NSLayoutAttributeLeft, -margin);
    [leftView.superview addConstraint:constraint];
    
    return constraint;
}

__unused static NSLayoutConstraint* gig_layout_right_view(UIView *rightView, UIView *leftView, CGFloat margin)
{
    return gig_layout_left_view(leftView, rightView, margin);
}

#endif
