//
//  GIGFormController.h
//  GiGLibrary
//
//  Created by Sergio Baró on 30/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GIGFormField;


@interface GIGFormController : NSObject

@property (weak, nonatomic, readonly) UIView *view;
@property (assign, nonatomic) CGFloat fieldsMargin;
@property (copy, nonatomic) NSDictionary *fieldValues;

- (instancetype)initWithParentView:(UIView *)view;
- (instancetype)initWithParentView:(UIView *)view headerView:(UIView *)headerView footerView:(UIView *)footerView;
- (instancetype)initWithParentView:(UIView *)view
                  headerView:(UIView *)headerView
                  footerView:(UIView *)footerView
          notificationCenter:(NSNotificationCenter *)notificationCenter NS_DESIGNATED_INITIALIZER;

- (void)loadFieldsFromJSONFile:(NSString *)jsonFile;
- (void)showFields:(NSArray *)fields;

- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;

- (BOOL)validateFields;

- (GIGFormField *)fieldWithTag:(NSString *)fieldTag;
- (id)valueForFieldWithTag:(NSString *)fieldTag;
- (void)setValue:(id)value forFieldWithTag:(NSString *)fieldTag;

- (void)formFieldDidStart:(GIGFormField *)formField;
- (void)formFieldDidFinish:(GIGFormField *)formField;
- (void)formField:(GIGFormField *)formField didChangeValue:(id)value;

@end
