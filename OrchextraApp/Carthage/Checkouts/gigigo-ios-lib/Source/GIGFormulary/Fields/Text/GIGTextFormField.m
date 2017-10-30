//
//  GIGTextFormField.m
//  GIGLibrary
//
//  Created by Sergio Baró on 19/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGTextFormField.h"

#import "GIGLayout.h"
#import "GIGValidator.h"


@interface GIGTextFormField ()

@property (strong, nonatomic) UIColor *textColor;

@end


@implementation GIGTextFormField

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
    [self initializeTextField];
}

- (void)initializeLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.font = [UIFont systemFontOfSize:14.0];
    self.textColor = label.textColor;
    [self addSubview:label];
    
    gig_autoresize(label, NO);
    gig_layout_left(label, 10.0);
    gig_layout_right(label, 10.0);
    gig_layout_top(label, 10.0);
    
    self.textLabel = label;
}

- (void)initializeTextField
{
    UITextField *textField = [[UITextField alloc] initWithFrame:self.bounds];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.delegate = self;
    [self addSubview:textField];
    
    gig_autoresize(textField, NO);
    gig_layout_left(textField, 10.0);
    gig_layout_right(textField, 10.0);
    gig_layout_bottom(textField, 10.0);
    
    gig_layout_below(textField, self.textLabel, 5.0);
    
    self.textField = textField;
}

#pragma mark - UIResponder (Override)

- (BOOL)canBecomeFirstResponder
{
    return [self.textField canBecomeFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    
    return [self.textField resignFirstResponder];
}

#pragma mark - GIGFormField (Override)

- (id)fieldValue
{
    return self.textField.text;
}

- (void)setFieldValue:(id)fieldValue
{
    self.textField.text = fieldValue;
}

- (BOOL)validate
{
    BOOL valid = [super validate];
    self.textLabel.textColor = valid ? self.textColor : [UIColor redColor];
    
    return valid;
}

#pragma mark - PRIVATE

#pragma mark - <UITextFieldDelegate>

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.formController formFieldDidStart:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.formController formField:self didChangeValue:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.formController formFieldDidFinish:self];
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.lengthValidator != nil && ![self.lengthValidator validate:finalString error:nil])
    {
        return NO;
    }
    
    if (self.characterValidator == nil)
    {
        return YES;
    }
    else
    {
        return [self.characterValidator validate:finalString error:nil];
    }
}

@end
