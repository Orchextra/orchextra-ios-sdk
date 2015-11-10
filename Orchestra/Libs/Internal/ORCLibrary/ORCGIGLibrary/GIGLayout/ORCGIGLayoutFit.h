//
//  GIGLayoutFit.h
//  layout
//
//  Created by Sergio Baró on 06/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#ifndef layout_GIGLayoutFit_h
#define layout_GIGLayoutFit_h


__unused static NSArray* gig_layout_fit_horizontal(UIView *subview)
{
    NSArray *constraints = gig_constraints(@"H:|[subview]|", nil, GIGViews(subview));
    [subview.superview addConstraints:constraints];
    return constraints;
}

__unused static NSArray* gig_layout_fit_vertical(UIView *subview)
{
    NSArray *constraints = gig_constraints(@"V:|[subview]|", nil, GIGViews(subview));
    [subview.superview addConstraints:constraints];
    
    return constraints;
}

__unused static NSArray* gig_layout_fit(UIView *subview)
{
    NSArray *horizontal = gig_layout_fit_horizontal(subview);
    NSArray *vertical = gig_layout_fit_vertical(subview);
    
    return [[NSArray arrayWithArray:horizontal] arrayByAddingObjectsFromArray:vertical];
}

__unused static NSArray* gig_layout_fit_views_horizontal(NSArray *subviews, BOOL top,
                                                NSNumber *heightRow, NSNumber *margin,
                                                NSNumber *paddingSuperview, NSNumber *paddingBetweenViews)
{
    UIView *view = subviews[0];
    NSDictionary *metrics = @{@"height" : heightRow,
                              @"margin" : margin,
                              @"paddingSuperview" : paddingSuperview,
                              @"paddingBetweenViews" : paddingBetweenViews};
    
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary new];
    NSMutableString *VFVertical = [[NSMutableString alloc] initWithString:@"|-paddingSuperview-"];
    
    for (int i = 0; i < subviews.count; i++)
    {
        gig_autoresize(subviews[i], NO);
        NSString *keyLabel = [NSString stringWithFormat:@"view%i", i];
        NSString *nextkeyLabel = [NSString stringWithFormat:@"view%i", i+1];
        viewsDictionary[keyLabel] = subviews[i];
        
        if (i < (subviews.count - 1))
        {
            [VFVertical appendFormat:@"[%@(%@)]-paddingBetweenViews-", keyLabel, nextkeyLabel];
        }
        else
        {
            [VFVertical appendFormat:@"[%@]-paddingSuperview-|", keyLabel];
        }
    }
    
    NSArray *vertical = [NSLayoutConstraint
                         constraintsWithVisualFormat:VFVertical
                         options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                         metrics:metrics views:viewsDictionary];    
    
    NSString *VFPosition;
    if (top)
    {
        VFPosition = @"V:|-margin-[view0(height)]";
    }
    else
    {
        VFPosition = @"V:[view0(height)]-margin-|";
    }
    
    NSArray *position = gig_constraints(VFPosition, metrics, viewsDictionary);
    [view.superview addConstraints:vertical];
    [view.superview addConstraints:position];
    [view.superview layoutIfNeeded];
    
    return [[NSArray arrayWithArray:position] arrayByAddingObjectsFromArray:vertical];
    
}

__unused static NSArray* gig_layout_fit_views_horizontal_default(NSArray *subviews, BOOL top, NSNumber *heightRow)
{
    return gig_layout_fit_views_horizontal(subviews, top, heightRow, @10, @20, @8);
}


#endif
