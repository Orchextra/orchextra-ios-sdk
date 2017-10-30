//
//  GIGFormFieldsBuilder.h
//  GIGLibrary
//
//  Created by Sergio Baró on 19/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GIGFormField;


@interface GIGFormFieldsBuilder : NSObject

- (NSArray *)fieldsFromJSONFile:(NSString *)file;
- (GIGFormField *)fieldWithJSON:(NSDictionary *)jsonField;

@end
