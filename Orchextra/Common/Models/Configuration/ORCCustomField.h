//
//  ORCCustomField.h
//  Orchextra
//
//  Created by Carlos Vicente on 8/6/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ORCCustomField : NSObject <NSCoding>

typedef NS_ENUM(NSUInteger, ORCCustomFieldType) {
    
    ORCCustomFieldTypeNone = 0,
    ORCCustomFieldTypeString = 1,
    ORCCustomFieldTypeBoolean = 2,
    ORCCustomFieldTypeInteger = 3,
    ORCCustomFieldTypeFloat = 4,
    ORCCustomFieldTypeDateTime = 5
};

@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSString *label;
@property (assign, nonatomic) ORCCustomFieldType type;
@property (strong, nonatomic) id value;

- (instancetype)initWithJSON:(NSDictionary *)json
                         key:(NSString *)key;

- (instancetype)initWithKey:(NSString *)key
                      label:(NSString *)label
                       type:(ORCCustomFieldType)type
                      value:(id)value;


@end
