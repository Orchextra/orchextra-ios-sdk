//
//  GIGMockClassAddress.h
//  GiGLibrary
//
//  Created by  Eduardo Parada on 6/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIGMockClassAddress : NSObject

@property (strong, nonatomic) NSString *street;
@property (assign, nonatomic) int number;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *country;

@end
