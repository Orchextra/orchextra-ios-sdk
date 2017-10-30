//
//  GIGCharactersValidator.h
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGStringValidator.h"


@interface GIGCharactersValidator : GIGStringValidator

- (instancetype)initWithCharacters:(NSString *)characters;
- (instancetype)initWithCharacterSet:(NSCharacterSet *)characterSet;

@end
