//
//  GIGFormField.h
//  GiGLibrary
//
//  Created by Sergio Baró on 30/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GIGFormController.h"

@class GIGValidator;


@interface GIGFormField : UIView

@property (weak, nonatomic) GIGFormController *formController;
@property (strong, nonatomic) GIGValidator *validator;
@property (copy, nonatomic) NSString *fieldTag;
@property (strong, nonatomic) id fieldValue;

- (BOOL)validate;

@end
