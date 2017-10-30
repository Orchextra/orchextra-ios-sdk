//
//  GIGFormFieldsBuilder.m
//  GIGLibrary
//
//  Created by Sergio Baró on 19/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGFormFieldsBuilder.h"

#import "GIGUtils.h"
#import "GIGJSON.h"
#import "NSBundle+GIGExtension.h"
#import "GIGLocalization.h"

#import "GIGFormFields.h"
#import "GIGValidators.h"
#import "GIGFormConstants.h"


@interface GIGFormFieldsBuilder ()

@property (strong, nonatomic) NSBundle *bundle;
@property (strong, nonatomic) NSDictionary *returnKeys;
@property (strong, nonatomic) NSDictionary *keyboardTypes;
@property (strong, nonatomic) NSDictionary *validators;

@end


@implementation GIGFormFieldsBuilder

- (instancetype)init
{
    NSBundle *bundle = [NSBundle mainBundle];
    
    return [self initWithBundle:bundle];
}

- (instancetype)initWithBundle:(NSBundle *)bundle
{
    self = [super init];
    if (self)
    {
        _bundle = bundle;
        
        [self initialize];
    }
    return self;
}

#pragma mark - Initialize

- (void)initialize
{
    self.returnKeys = @{GIGFormReturnKeyDone: @(UIReturnKeyDone),
                        GIGFormReturnKeyNext: @(UIReturnKeyNext),
                        GIGFormReturnKeySend: @(UIReturnKeySend),
                        GIGFormReturnKeyGo: @(UIReturnKeyGo)
                        };
    
    self.keyboardTypes = @{GIGFormKeyboardTypeText: @(UIKeyboardTypeDefault),
                           GIGFormKeyboardTypeEmail: @(UIKeyboardTypeEmailAddress),
                           GIGFormKeyboardTypeNumbers: @(UIKeyboardTypeNumbersAndPunctuation),
                           GIGFormKeyboardTypeNumberPad: @(UIKeyboardTypeNumberPad)
                           };
    
    self.validators = @{GIGFormValidatorText: [GIGTextValidator class],
                        GIGFormValidatorNumeric: [GIGNumericValidator class],
                        GIGFormValidatorMail: [GIGMailValidator class],
                        GIGFormValidatorPhone: [GIGPhoneValidator class],
                        GIGFormValidatorPostalCode: [GIGPostalCodeValidator class],
                        GIGFormValidatorBool: [GIGBoolValidator class]
                        };
}

#pragma mark - PUBLIC

- (NSArray *)fieldsFromJSONFile:(NSString *)file
{
    NSArray *json = [self.bundle loadJSONFile:file rootNode:@"fields"];
    
    NSMutableArray *fields = [[NSMutableArray alloc] initWithCapacity:json.count];
    for (NSDictionary *jsonField in json)
    {
        GIGFormField *field = [self fieldWithJSON:jsonField];
        if (field != nil)
        {
            [fields addObject:field];
        }
    }
    
    return [fields copy];
}

- (GIGFormField *)fieldWithJSON:(NSDictionary *)jsonField
{
    NSString *type = [jsonField stringForKey:@"type"];
    
    GIGFormField *field = nil;
    if ([type isEqualToString:GIGFormFieldTypeText])
    {
        field = [self textFieldWithJSON:jsonField];
    }
    else if ([type isEqualToString:GIGFormFieldTypePassword])
    {
        field = [self passwordFieldWithJSON:jsonField];
    }
    else if ([type isEqualToString:GIGFormFieldTypeEMail])
    {
        field = [self mailFieldWithJSON:jsonField];
    }
    else if ([type isEqualToString:GIGFormFieldTypePhone])
    {
        field = [self phoneFieldWithJSON:jsonField];
    }
    else if ([type isEqualToString:GIGFormFieldTypeCheck])
    {
        field = [self checkFieldWithJSON:jsonField];
    }
    else if ([type isEqualToString:GIGFormFieldTypeMessage])
    {
        field = [self messageFieldWithJSON:jsonField];
    }
    
    field.fieldTag = [jsonField stringForKey:@"tag"];
    field.fieldValue = [jsonField objectForKey:@"value"];
    
    return field;
}

#pragma mark - PRIVATE

- (GIGTextFormField *)textFieldWithJSON:(NSDictionary *)jsonField
{
    GIGTextFormField *field = [self loadFieldFromClass:[GIGTextFormField class]];
    field.textLabel.text = GIGLocalize([jsonField stringForKey:@"label"]);
    field.textField.placeholder = GIGLocalize([jsonField stringForKey:@"placeholder"]);
    field.textField.secureTextEntry = [jsonField boolForKey:@"secure"];
    
    [self setReturnKeyOnTextInput:field.textField fromJSON:jsonField];
    [self setKeyboardTypeOnTextInput:field.textField fromJSON:jsonField];
    [self setValidatorsToTextField:field fromJSON:jsonField];
    
    return field;
}

- (GIGTextFormField *)passwordFieldWithJSON:(NSDictionary *)jsonField
{
    GIGTextFormField *field = [self textFieldWithJSON:jsonField];
    field.textField.secureTextEntry = YES;
    
    return field;
}

- (GIGTextFormField *)mailFieldWithJSON:(NSDictionary *)jsonField
{
    GIGTextFormField *field = [self textFieldWithJSON:jsonField];
    field.textField.keyboardType = UIKeyboardTypeEmailAddress;
    field.validator = [[GIGMailValidator alloc] init];
    field.validator.mandatory = [jsonField boolForKey:@"mandatory"];
    
    return field;
}

- (GIGTextFormField *)phoneFieldWithJSON:(NSDictionary *)jsonField
{
    GIGTextFormField *field = [self textFieldWithJSON:jsonField];
    field.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    field.validator = [[GIGPhoneValidator alloc] init];
    field.validator.mandatory = [jsonField boolForKey:@"mandatory"];
    
    return field;
}

- (GIGFormField *)checkFieldWithJSON:(NSDictionary *)jsonField
{
    GIGCheckFormField *field = [self loadFieldFromClass:[GIGCheckFormField class]];
    field.textLabel.text = GIGLocalize([jsonField stringForKey:@"label"]);
    
    [self setValidatorToField:field fromJSON:jsonField];
    
    return field;
}

- (GIGFormField *)messageFieldWithJSON:(NSDictionary *)jsonField
{
    GIGMessageFormField *field = [self loadFieldFromClass:[GIGMessageFormField class]];
    field.textLabel.text = GIGLocalize([jsonField stringForKey:@"label"]);
    
    return field;
}

- (void)setReturnKeyOnTextInput:(id<UITextInputTraits>)textInput fromJSON:(NSDictionary *)jsonField
{
    NSString *returnKey = [jsonField stringForKey:@"return_key"];
    NSNumber *returnKeyNumber = self.returnKeys[returnKey];
    if (returnKey.length > 0 && returnKeyNumber != nil)
    {
        textInput.returnKeyType = [returnKeyNumber integerValue];
    }
    else
    {
        textInput.returnKeyType = UIReturnKeyNext;
    }
}

- (void)setKeyboardTypeOnTextInput:(id<UITextInputTraits>)textInput fromJSON:(NSDictionary *)jsonField
{
    NSString *keyboardType = [jsonField stringForKey:@"keyboard"];
    if (keyboardType.length > 0 && self.keyboardTypes[keyboardType] != nil)
    {
        textInput.keyboardType = [self.keyboardTypes[keyboardType] integerValue];
    }
}

- (void)setValidatorToField:(GIGFormField *)field fromJSON:(NSDictionary *)jsonField
{
    NSString *validatorType = [jsonField stringForKey:@"validator"];
    
    Class validatorClass = self.validators[validatorType];
    
    if (validatorClass != nil)
    {
        field.validator = [[validatorClass alloc] init];
        field.validator.mandatory = [jsonField boolForKey:@"mandatory"];
    }
}

- (void)setValidatorsToTextField:(GIGTextFormField *)field fromJSON:(NSDictionary *)jsonField
{
    // validator
    [self setValidatorToField:field fromJSON:jsonField];
    
    // characters
    
    // length
    NSInteger maxLength = [jsonField integerForKey:@"maxLength"];
    NSInteger minLength = [jsonField integerForKey:@"minLength"];
    if (maxLength > 0 || minLength > 0)
    {
        GIGLengthValidator *lengthValidator = [[GIGLengthValidator alloc] initWithMinLength:minLength maxLength:maxLength];
        lengthValidator.mandatory = NO;
        field.lengthValidator = lengthValidator;
    }
}

#pragma mark - PRIVATE (Field Loading)

- (id)loadFieldFromClass:(Class)c
{
    NSString *className = NSStringFromClass(c);
    
    return [self loadFieldFromClassName:className];
}

- (id)loadFieldFromClassName:(NSString *)className
{
    Class c = NSClassFromString(className);
    
    if (c == nil)
    {
        return nil;
    }
    
    if ([self.bundle pathForResource:className ofType:@"nib"] != nil)
    {
        return [c loadFromNib];
    }
    
    return [[c alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

@end
