//
//  ORCTrigger.h
//  Orchestra
//
//  Created by Judith Medina on 7/5/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ORCActionInterface;


@interface ORCAction : NSObject

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *messageNotification;
@property (strong, nonatomic) NSString *titleNotification;

- (instancetype)initWithJSON:(NSDictionary *)json;
- (instancetype)initWithType:(NSString *)type;
- (instancetype)initWithType:(NSString *)type json:(NSDictionary *)json;

- (void)executeActionWithActionInterface:(id<ORCActionInterface>)actionInterface;

@end
