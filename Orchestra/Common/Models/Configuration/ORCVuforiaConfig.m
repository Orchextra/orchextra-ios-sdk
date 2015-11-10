//
//  ORCVuforiaConfig.m
//  Orchestra
//
//  Created by Judith Medina on 13/10/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import "ORCVuforiaConfig.h"

NSString * const ORCVuforiaLicense = @"ORCVuforiaLicense";
NSString * const ORCAccessKeyVuforia = @"ORCAccessKeyVuforia";
NSString * const ORCSecretKeyVuforia = @"ORCSecretKeyVuforia";

@implementation ORCVuforiaConfig

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        _licenseKey = json[@"licenseKey"];
        _accessKey = json[@"clientAccessKey"];
        _secretKey = json[@"clientSecretKey"];

    }
    return self;
}

#pragma mark - CODING

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        _licenseKey = [aDecoder decodeObjectForKey:ORCVuforiaLicense];
        _accessKey = [aDecoder decodeObjectForKey:ORCAccessKeyVuforia];
        _secretKey = [aDecoder decodeObjectForKey:ORCSecretKeyVuforia];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_licenseKey forKey:ORCVuforiaLicense];
    [aCoder encodeObject:_accessKey forKey:ORCAccessKeyVuforia];
    [aCoder encodeObject:_secretKey forKey:ORCSecretKeyVuforia];
}


@end
