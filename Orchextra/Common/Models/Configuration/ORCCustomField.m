//
//  ORCCustomField.m
//  Orchextra
//
//  Created by Carlos Vicente on 8/6/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCCustomField.h"

#import <GIGLibrary/NSDictionary+GIGJSON.h>

NSString * const KEY_JSON   = @"key";
NSString * const LABEL_JSON = @"label";
NSString * const TYPE_JSON  = @"type";
NSString * const VALUE_JSON  = @"value";

@implementation ORCCustomField

#pragma mark - INIT

- (instancetype)initWithJSON:(NSDictionary *)json
                         key:(NSString *)key
{
    self = [super init];
    if (self)
    {
        NSString *typeString = json[TYPE_JSON];
        
        _key = key;
        _label = json[LABEL_JSON];
        _type = [self typeFromString:typeString];
        _value = nil;
    }
    
    return self;
}

- (instancetype)initWithKey:(NSString *)key
                      label:(NSString *)label
                       type:(ORCCustomFieldType)type
                      value:(id)value
{
    
    self = [super init];
    if (self)
    {
        _key = key;
        _label = label;
        _type = type;
        _value = value;
    }

    return self;
}

#pragma mark - PRIVATE

- (ORCCustomFieldType)typeFromString:(NSString *)typeString
{
    ORCCustomFieldType type = ORCCustomFieldTypeNone;
    if ([@"string" isEqualToString:typeString])
    {
        type = ORCCustomFieldTypeString;
        
    } else if ([@"boolean" isEqualToString:typeString])
    {
        type = ORCCustomFieldTypeBoolean;
    
    } else if ([@"integer" isEqualToString:typeString])
    {
        type = ORCCustomFieldTypeInteger;
        
    } else if ([@"float" isEqualToString:typeString])
    {
        type = ORCCustomFieldTypeFloat;
        
    } else if ([@"datetime" isEqualToString:typeString])
    {
        type = ORCCustomFieldTypeDateTime;
    }
    
    return type;
}

#pragma mark - CODING

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _key = [aDecoder decodeObjectForKey:KEY_JSON];
        _label = [aDecoder decodeObjectForKey:LABEL_JSON];
        _value = [aDecoder decodeObjectForKey:VALUE_JSON];
        NSNumber *typeObject = [aDecoder decodeObjectForKey:TYPE_JSON];
        _type = [typeObject integerValue];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.key forKey:KEY_JSON];
    [aCoder encodeObject:self.label forKey:LABEL_JSON];
    [aCoder encodeObject:self.value forKey:VALUE_JSON];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.type]
                  forKey:TYPE_JSON];
}

@end
