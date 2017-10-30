//
//  GIGMessageFormField.m
//  GIGLibrary
//
//  Created by Sergio Baró on 20/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGMessageFormField.h"

#import "GIGLayout.h"


@implementation GIGMessageFormField

#pragma mark - INITIALIZE

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.font = [UIFont systemFontOfSize:14.0];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:label];
    
    gig_autoresize(label, NO);
    gig_layout_top(label, 10.0);
    gig_layout_bottom(label, 10.0);
    gig_layout_right(label, 10.0);
    gig_layout_left(label, 10.0);
    
    self.textLabel = label;
}


@end
