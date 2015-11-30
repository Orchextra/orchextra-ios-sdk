//
//  ORCConfigurationSdk.h
//  Orchestra
//
//  Created by Judith Medina on 7/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ORCUserGender)
{
    ORCGenderFemale,
    ORCGenderMale
};

@class ORCConfigurationInteractor;

@interface ORCUser : NSObject <NSCoding>

@property (strong, nonatomic) NSString *crmID;
@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSString *deviceToken;
@property (assign, nonatomic) ORCUserGender gender;
@property (strong, nonatomic) ORCConfigurationInteractor *interactor;

+ (ORCUser *)currentUser;
- (void)saveUser;

- (NSString *)birthdayFormatted;
- (NSString *)genderUser;
- (BOOL)isSameUser:(ORCUser *)user;

@end
