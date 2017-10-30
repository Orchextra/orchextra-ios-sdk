//
//  GIGCheckFormField.h
//  GIGLibrary
//
//  Created by Sergio Baró on 20/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGFormField.h"


@interface GIGCheckFormField : GIGFormField

@property (weak, nonatomic) UILabel *textLabel;
@property (weak, nonatomic) UISwitch *check;

@end
