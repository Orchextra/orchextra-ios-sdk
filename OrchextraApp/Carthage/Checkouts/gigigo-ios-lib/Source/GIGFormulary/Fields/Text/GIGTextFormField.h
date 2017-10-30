//
//  GIGTextFormField.h
//  GIGLibrary
//
//  Created by Sergio Baró on 19/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGFormField.h"

@class GIGValidator;


@interface GIGTextFormField : GIGFormField
<UITextFieldDelegate>

@property (weak, nonatomic) UILabel *textLabel;
@property (weak, nonatomic) UITextField *textField;

@property (strong, nonatomic) GIGValidator *characterValidator;
@property (strong, nonatomic) GIGValidator *lengthValidator;

@end
