//
//  GIGLayoutBase.h
//  layout
//
//  Created by Sergio Baró on 06/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#ifndef layout_GIGLayoutBase_h
#define layout_GIGLayoutBase_h


#define GIGViews(...) NSDictionaryOfVariableBindings(__VA_ARGS__)


__unused static CGSize gig_layout_size(UIView *view)
{
    return [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

__unused static void gig_autoresize(UIView *view, BOOL autoresize)
{
    view.translatesAutoresizingMaskIntoConstraints = autoresize;
}

__unused static NSArray* gig_constraints(NSString *format, NSDictionary *metrics, NSDictionary *views)
{
    return [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views];
}

__unused static NSLayoutConstraint* gig_constraint(UIView *view1, NSLayoutAttribute attribute1, NSLayoutRelation relation, UIView *view2, NSLayoutAttribute attribute2, CGFloat constant)
{
    return [NSLayoutConstraint constraintWithItem:view1
                                        attribute:attribute1
                                        relatedBy:relation
                                           toItem:view2
                                        attribute:attribute2
                                       multiplier:1.0
                                         constant:constant];
}

__unused static NSLayoutConstraint* gig_constraint_attribute_view(UIView *view1, UIView *view2, NSLayoutAttribute attribute, CGFloat constant)
{
    return gig_constraint(view1, attribute, NSLayoutRelationEqual, view2, attribute, constant);
}

__unused static NSLayoutConstraint* gig_constraint_attribute(UIView *view, NSLayoutAttribute attribute, CGFloat constant)
{
    return gig_constraint(view, attribute, NSLayoutRelationEqual, nil, NSLayoutAttributeNotAnAttribute, constant);
}


#endif
