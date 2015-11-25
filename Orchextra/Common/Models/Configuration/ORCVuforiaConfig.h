//
//  ORCVuforiaConfig.h
//  Orchestra
//
//  Created by Judith Medina on 13/10/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ORCVuforiaConfig : NSObject <NSCoding>

@property (strong, nonatomic) NSString *licenseKey;
@property (strong, nonatomic) NSString *accessKey;
@property (strong, nonatomic) NSString *secretKey;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
