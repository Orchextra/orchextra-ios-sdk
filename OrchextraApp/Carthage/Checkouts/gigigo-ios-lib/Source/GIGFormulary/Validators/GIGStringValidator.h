//
//  GIGStringValidator.h
//  GiGLibrary
//
//  Created by Sergio Baró on 30/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGValidator.h"


@interface GIGStringValidator : GIGValidator

- (BOOL)validate:(NSString *)value error:(NSError * __autoreleasing *)error;

@end
