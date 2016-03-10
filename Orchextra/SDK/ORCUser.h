//
//  ORCUser.h
//  Orchestra
//
//  Created by Judith Medina on 7/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ORCUserGender)
{
    ORCGenderNone = 0,
    ORCGenderFemale = 1,
    ORCGenderMale = 2
};

@interface ORCUser : NSObject <NSCoding>

@property (strong, nonatomic) NSString *crmID;
@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSString *deviceToken;
@property (assign, nonatomic) ORCUserGender gender;

- (BOOL)crmHasChanged:(ORCUser *)user;
- (BOOL)isSameUser:(ORCUser *)user;

@end
