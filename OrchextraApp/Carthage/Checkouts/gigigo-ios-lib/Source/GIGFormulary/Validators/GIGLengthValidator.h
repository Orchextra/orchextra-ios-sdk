//
//  GIGLengthValidator.h
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGStringValidator.h"


@interface GIGLengthValidator : GIGStringValidator

@property (assign, nonatomic, readonly) NSInteger minLength;
@property (assign, nonatomic, readonly) NSInteger maxLength;

- (instancetype)initWithMinLength:(NSInteger)minLength;
- (instancetype)initWithMaxLength:(NSInteger)maxLength;
- (instancetype)initWithMinLength:(NSInteger)minLength maxLength:(NSInteger)maxLength;

@end
