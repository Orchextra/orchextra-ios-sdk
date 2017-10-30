//
//  GIGRegexpValidator.h
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGStringValidator.h"


@interface GIGRegexpValidator : GIGStringValidator

@property (strong, nonatomic, readonly) NSRegularExpression *regexp;

- (instancetype)initWithRegexp:(NSRegularExpression *)regexp;
- (instancetype)initWithRegexpPattern:(NSString *)regexpPattern;

@end
