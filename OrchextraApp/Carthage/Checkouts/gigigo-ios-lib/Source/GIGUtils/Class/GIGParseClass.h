//
//  GIGParseClass.h
//  GiGLibrary
//
//  Created by  Eduardo Parada on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIGParseClass : NSObject


/*!
    @brief This method converts the class properties to a dictionary.
 
    @discussion Where the key is the name of the property and the value its content.
 
                To use it, simply call [GIGParseClass parseClass:NameClass];
 
    @param  parseClass The input value representing any class.
 
    @return NSDictionary Key = Name Property, Value = value of content.
 */


- (NSDictionary *)parseClass:(id)parseClass;

+ (NSDictionary *)parseClass:(id)parseClass;

@end
