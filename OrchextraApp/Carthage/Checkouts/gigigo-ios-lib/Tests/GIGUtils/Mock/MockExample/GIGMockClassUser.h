//
//  GIGMockClassUser.h
//  GiGLibrary
//
//  Created by  Eduardo Parada on 6/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GIGMockClassAddress.h"


@interface GIGMockClassUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *secondLastName;
@property (assign, nonatomic) int age;

@property (strong, nonatomic) GIGMockClassAddress *address;

@end
