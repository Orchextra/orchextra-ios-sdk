//
//  GIGCheckFormField.m
//  GIGLibrary
//
//  Created by Sergio Baró on 20/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGCheckFormField.h"

#import "GIGLayout.h"


@interface GIGCheckFormField ()

@property (strong, nonatomic) UIColor *textColor;

@end


@implementation GIGCheckFormField

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
    [self initializeLabel];
    [self initializeCheck];
}

- (void)initializeLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.font = [UIFont systemFontOfSize:14.0];
    self.textColor = label.textColor;
    [self addSubview:label];
    
    gig_autoresize(label, NO);
    gig_layout_center_vertical(label, 0.0);
    gig_layout_left(label, 10.0);
    
    self.textLabel = label;
}

- (void)initializeCheck
{
    UISwitch *check = [[UISwitch alloc] initWithFrame:self.bounds];
    [check addTarget:self action:@selector(checkValueChanged) forControlEvents:UIControlEventValueChanged];
    [self addSubview:check];
    
    gig_autoresize(check, NO);
    gig_layout_top(check, 10.0);
    gig_layout_bottom(check, 10.0);
    gig_layout_right(check, 10.0);
    
    self.check = check;
}

#pragma mark - ACTIONS

- (void)checkValueChanged
{
    [self.formController formField:self didChangeValue:self.fieldValue];
}

#pragma mark - PUBLIC

#pragma mark - UIResponder (Override)

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

#pragma mark - GIGFormField (Override)

- (id)fieldValue
{
    return @(self.check.on);
}

- (void)setFieldValue:(id)fieldValue
{
    if ([fieldValue respondsToSelector:@selector(boolValue)])
    {
        BOOL value = [fieldValue boolValue];
        [self.check setOn:value animated:YES];
    }
}

- (BOOL)validate
{
    BOOL valid = [super validate];
    self.textLabel.textColor = valid ? self.textColor : [UIColor redColor];
    
    return valid;
}

@end
