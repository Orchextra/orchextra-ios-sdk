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

@property (strong, nonatomic) NSString *trackId;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *bodyNotification;
@property (strong, nonatomic) NSString *titleNotification;
@property (strong, nonatomic) NSString *launchedByTriggerCode;

// Schedule
@property (assign, nonatomic) NSInteger scheduleTime;
@property (assign, nonatomic) BOOL cancelable;
@property (assign, nonatomic) BOOL actionWithUserInteraction;

- (instancetype)initWithJSON:(NSDictionary *)json;
- (instancetype)initWithType:(NSString *)type;
- (instancetype)initWithType:(NSString *)type json:(NSDictionary *)json;

- (void)executeActionWithActionInterface:(id<ORCActionInterface>)actionInterface;

- (NSDictionary *)toDictionary;
- (NSString *)description;

@end
