//
//  ORCBarButtonItem.m
//  Orchextra
//
//  Created by Judith Medina on 31/8/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCBarButtonItem.h"
#import "ORCSettingsPersister.h"
#import "ORCThemeSdk.h"


@interface ORCBarButtonItem()

@property (strong, nonatomic) ORCSettingsPersister *storage;
@property (strong, nonatomic) ORCThemeSdk *theme;

@end


@implementation ORCBarButtonItem

#pragma mark - INIT


- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action
{
    self = [super initWithBarButtonSystemItem:systemItem target:target action:action];
    
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

#pragma mark - CUSTOM

- (void)initialize
{
    self.storage = [[ORCSettingsPersister alloc] init];
    self.theme = [self.storage loadThemeSdk];
    self.tintColor = [self.theme secondaryColor];
}



@end
