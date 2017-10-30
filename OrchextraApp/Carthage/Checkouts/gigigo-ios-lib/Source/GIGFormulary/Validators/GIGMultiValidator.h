//
//  GIGMultiValidator.h
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGValidator.h"


@interface GIGMultiValidator : GIGValidator

- (instancetype)initWithValidators:(NSArray *)validators;

@end
