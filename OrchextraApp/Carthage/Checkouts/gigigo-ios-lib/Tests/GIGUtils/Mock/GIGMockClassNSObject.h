//
//  GIGMockClassNSObject.h
//  GiGLibrary
//
//  Created by  Eduardo Parada on 6/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIGMockClassNSObject : NSObject <NSCoding>

@property (strong, nonatomic) NSString *stringNSObject;
@property (assign, nonatomic) NSInteger integerNSObject;

@end
