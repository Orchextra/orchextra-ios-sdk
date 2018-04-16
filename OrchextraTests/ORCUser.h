//
//  ORCUser.h
//  Orchestra
//
//  Created by Judith Medina on 7/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORCBusinessUnit;
@class ORCCustomField;
@class ORCTag;

typedef NS_ENUM(NSUInteger, ORCUserGender)
{
    ORCGenderNone = 0,
    ORCGenderFemale = 1,
    ORCGenderMale = 2
};

@interface ORCUser : NSObject <NSCoding>

@property (strong, nonatomic) NSString *crmID;
@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSArray <ORCTag *> *tags;
@property (strong, nonatomic) NSArray <ORCCustomField *> *customFields;
@property (strong, nonatomic) NSArray <ORCBusinessUnit *> *businessUnits;
@property (strong, nonatomic) NSString *deviceToken;
@property (assign, nonatomic) ORCUserGender gender;

/**
 Method to update one custom field
 @param: value, key of ORCCustomField
 */
- (BOOL)updateCustomFieldValue:(id)value withKey:(NSString *)key;

/**
    Method to check if the CRMID has changed
    @param: user,check new user.
*/
- (BOOL)crmHasChanged:(ORCUser *)user;

/**
    Method to check if both user are the same.
    @param: user,check new user.
 */
- (BOOL)isSameUser:(ORCUser *)user;


@end
