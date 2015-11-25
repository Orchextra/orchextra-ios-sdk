//
//  GIGLocalization.h
//  giglibrary
//
//  Created by Sergio Baró on 06/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#ifndef utils_GIGLocalization_h
#define utils_GIGLocalization_h

#import <Foundation/Foundation.h>


#define GIGLocalize(key) NSLocalizedString(key, nil)
#define GIGLocalizeFormat(format, ...) [NSString stringWithFormat:GIGLocalize(format), __VA_ARGS__]
#define GIGLocalizeParams(localizationKey, dictionary) GIGLocalizeParamsFunction(localizationKey, dictionary)


__unused static void GIGShowNonLocalizedStrings(BOOL show)
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (show)
    {
        [defaults setBool:YES forKey:@"NSShowNonLocalizedStrings"];
    }
    else
    {
        [defaults removeObjectForKey:@"NSShowNonLocalizedStrings"];
    }
    [defaults synchronize];
}


__unused static NSString* GIGLocalizeParamsFunction(NSString *localizationKey, NSDictionary *dictionary)
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:GIGLocalize(localizationKey)];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, __unused BOOL *stop){
        NSString *target = [NSString stringWithFormat:@"{%@}", key];
        NSString *replacement = [NSString stringWithFormat:@"%@", obj];
        [result replaceOccurrencesOfString:target withString:replacement options:kNilOptions range:NSMakeRange(0, result.length)];
    }];
    
    return [result copy];
}


#endif
