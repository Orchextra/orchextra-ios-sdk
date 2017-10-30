//
//  GIGFormController.m
//  GiGLibrary
//
//  Created by Sergio Baró on 30/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGFormController.h"

#import "GIGUtils.h"
#import "GIGLayout.h"

#import "GIGFormField.h"
#import "GIGFormFieldsBuilder.h"


@interface GIGFormController ()
<UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIView *parentView;
@property (weak, nonatomic) UIView *headerView;
@property (weak, nonatomic) UIView *footerView;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIView *contentView;
@property (weak, nonatomic) UIView *fieldsContentView;

@property (strong, nonatomic) NSNotificationCenter *notificationCenter;

@property (copy, nonatomic) NSArray *formFields;
@property (strong, nonatomic) NSMutableDictionary *formValues;

@end


@implementation GIGFormController

- (instancetype)init
{
    return [self initWithParentView:nil];
}

- (instancetype)initWithParentView:(UIView *)view
{
    return [self initWithParentView:view headerView:nil footerView:nil];
}

- (instancetype)initWithParentView:(UIView *)view headerView:(UIView *)headerView footerView:(UIView *)footerView
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    return [self initWithParentView:view headerView:headerView footerView:footerView notificationCenter:notificationCenter];
}

- (instancetype)initWithParentView:(UIView *)parentView headerView:(UIView *)headerView footerView:(UIView *)footerView notificationCenter:(NSNotificationCenter *)notificationCenter
{
    self = [super init];
    if (self)
    {
        _parentView = parentView;
        _headerView = headerView;
        _footerView = footerView;
        _notificationCenter = notificationCenter;
        
        [self initialize];
    }
    return self;
}

- (void)dealloc
{
    [self.notificationCenter removeObserver:self];
}

#pragma mark - INITIALIZE

- (void)initialize
{
    [self.notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [self.notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self initializeScrollView];
    [self initializeContentView];
    [self initializeFieldsContentView];
    
    [self updateContent];
}

- (void)initializeScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    scrollView.alwaysBounceVertical = YES;
    [self.parentView addSubview:scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
    tap.delegate = self;
    [scrollView addGestureRecognizer:tap];
    
    gig_autoresize(scrollView, NO);
    gig_layout_fit(scrollView);
    
    self.scrollView = scrollView;
}

- (void)initializeContentView
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.scrollView addSubview:contentView];
    
    gig_autoresize(contentView, NO);
    gig_layout_fit(contentView);
    gig_layout_top(contentView, 0.0);
    gig_constrain_width(contentView, [UIScreen mainScreen].bounds.size.width);
    
    self.contentView = contentView;
}

- (void)initializeFieldsContentView
{
    UIView *fieldsContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.contentView addSubview:fieldsContentView];
    
    gig_autoresize(fieldsContentView, NO);
    gig_layout_fit_horizontal(fieldsContentView);
    
    self.fieldsContentView = fieldsContentView;
}

#pragma mark - ACTIONS

- (void)tapBackground:(UITapGestureRecognizer *)tapGesture
{
    [self.parentView endEditing:YES];
}

#pragma mark - NOTIFICATIONS

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height, 0);
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
}

#pragma mark - ACCESSORS

- (NSDictionary *)fieldValues
{
    return [self.formValues copy];
}

- (void)setFieldValues:(NSDictionary *)fieldValues
{
    self.formValues = [fieldValues mutableCopy];
    
    __weak typeof(self) this = self;
    [fieldValues enumerateKeysAndObjectsUsingBlock:^(NSString *fieldTag, id value, __unused BOOL *stop) {
        GIGFormField *field = [this fieldWithTag:fieldTag];
        field.fieldValue = value;
    }];
}

- (UIView *)view
{
    return self.scrollView;
}

#pragma mark - PUBLIC

- (void)loadFieldsFromJSONFile:(NSString *)jsonFile
{
    GIGFormFieldsBuilder *builder = [[GIGFormFieldsBuilder alloc] init];
    NSArray *fields = [builder fieldsFromJSONFile:jsonFile];
    
    [self showFields:fields];
}

- (void)showFields:(NSArray *)fields
{
    self.formValues = [[NSMutableDictionary alloc] initWithCapacity:fields.count];
    self.formFields = fields;
    
    for (GIGFormField *field in fields)
    {
        if (field.fieldValue != nil)
        {
            self.formValues[field.fieldTag] = field.fieldValue;
        }
    }
    
    [self updateContent];
}

- (BOOL)becomeFirstResponder
{
    return [self.formFields.firstObject becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.contentView endEditing:YES];
}

- (BOOL)validateFields
{
    BOOL valid = YES;
    
    for (GIGFormField *field in self.formFields)
    {
        valid = ([field validate] && valid);
    }
    
    return valid;
}

- (GIGFormField *)fieldWithTag:(NSString *)fieldTag
{
    for (GIGFormField *field in self.formFields)
    {
        if ([field.fieldTag isEqualToString:fieldTag])
        {
            return field;
        }
    }
    
    return nil;
}

- (id)valueForFieldWithTag:(NSString *)fieldTag
{
    GIGFormField *field = [self fieldWithTag:fieldTag];
    
    return field.fieldValue;
}

- (void)setValue:(id)value forFieldWithTag:(NSString *)fieldTag
{
    GIGFormField *field = [self fieldWithTag:fieldTag];
    field.fieldValue = value;
}

- (void)formFieldDidStart:(GIGFormField *)formField
{
    [self.scrollView scrollRectToVisible:formField.frame animated:YES];
}

- (void)formFieldDidFinish:(GIGFormField *)formField
{
    GIGFormField *nextField = [self nextFieldTo:formField];
    
    if (nextField != nil)
    {
        if ([nextField canBecomeFirstResponder])
        {
            [nextField becomeFirstResponder];
        }
        else
        {
            [formField resignFirstResponder];
        }
    }
    else
    {
        [self resignFirstResponder];
        [self validateFields];
    }
}

- (void)formField:(GIGFormField *)formField didChangeValue:(id)value
{
    self.formValues[formField.fieldTag] = value;
}

#pragma mark - PRIVATE (Fields)

- (GIGFormField *)nextFieldTo:(GIGFormField *)formField
{
    NSInteger nextIndex = [self.formFields indexOfObject:formField] + 1;
    if (nextIndex < self.formFields.count)
    {
        return self.formFields[nextIndex];
    }
    
    return nil;
}

#pragma mark - PRIVATE (Content Views)

- (void)updateContent
{
    [self.headerView removeFromSuperview];
    [self.fieldsContentView removeSubviews];
    [self.footerView removeFromSuperview];
    
    [self addHeaderView];
    [self addFields];
    [self addFooterView];
}

- (void)addHeaderView
{
    if (self.headerView != nil)
    {
        [self.contentView addSubview:self.headerView];
        
        gig_autoresize(self.headerView, NO);
        gig_layout_fit_horizontal(self.headerView);
        gig_layout_top(self.headerView, 0);
        gig_layout_above(self.headerView, self.fieldsContentView, 0);
    }
    else
    {
        gig_layout_top(self.fieldsContentView, 0);
    }
}

- (void)addFooterView
{
    if (self.footerView != nil)
    {
        [self.contentView addSubview:self.footerView];
        
        gig_autoresize(self.footerView, NO);
        gig_layout_fit_horizontal(self.footerView);
        gig_layout_below(self.footerView, self.fieldsContentView, 0);
        gig_layout_bottom(self.footerView, 0);
    }
    else
    {
        gig_layout_bottom(self.fieldsContentView, 0);
    }
}

- (void)addFields
{
    UIView *lastView = nil;
    
    for (GIGFormField *field in self.formFields)
    {
        field.formController = self;
        [self.fieldsContentView addSubview:field];
        
        gig_autoresize(field, NO);
        gig_layout_fit_horizontal(field);
        
        if (lastView != nil)
        {
            gig_layout_below(field, lastView, self.fieldsMargin);
        }
        else
        {
            gig_layout_top(field, 0);
        }
        
        lastView = field;
    }
    
    if (lastView != nil)
    {
        gig_layout_bottom(lastView, 0);
    }
}

#pragma mark - DELEGATES

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]])
    {
        return NO;
    }
    
    return YES;
}


@end
