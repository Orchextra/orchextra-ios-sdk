//
//  ORCLocationStorage.m
//  Orchestra
//
//  Created by Judith Medina on 1/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCUserLocationPersister.h"
#import "NSUserDefaults+ORCGIGArchive.h"
#import "ORCFormatterParameters.h"
#import "ORCRegion.h"

NSString * const ORCLastKnownPlacemark = @"ORCLastKnownPlacemark";
NSString * const ORCLastKnownLocation = @"ORCLastKnownLocation";
NSString * const ORCAuthorizationStatus = @"ORCAuthorizationStatus";
NSString * const ORCListRegions = @"ORCListRegions";


@interface ORCUserLocationPersister ()

@property (strong, nonatomic) NSUserDefaults *userdefaults;

@end


@implementation ORCUserLocationPersister

- (instancetype)init
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [self initWithUserDefaults:userDefaults];
}

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults
{
    self = [super init];
    
    if (self)
    {
        _userdefaults = userDefaults;
    }
    
    return self;
}

#pragma mark - Location

- (CLLocation *)loadLastLocation
{
    return [self.userdefaults unarchiveObjectForKey:ORCLastKnownLocation];
}

- (void)storeLastLocation:(CLLocation *)location
{
    [self.userdefaults archiveObject:location forKey:ORCLastKnownLocation];
    [self.userdefaults synchronize];
}

#pragma mark - Placemark

- (CLPlacemark *)loadLastPlacemark
{
    return [self.userdefaults unarchiveObjectForKey:ORCLastKnownPlacemark];
}

- (void)storeLastPlacemark:(CLPlacemark *)placemark
{
    [self.userdefaults archiveObject:placemark forKey:ORCLastKnownPlacemark];
    [self.userdefaults synchronize];
}

#pragma mark - User Permissions Location

- (BOOL)loadUserLocationPermission
{
    return [self.userdefaults boolForKey:ORCAuthorizationStatus];
}

- (void)storeUserLocationPermission:(BOOL)hasPermission
{
    [self.userdefaults setBool:hasPermission forKey:ORCAuthorizationStatus];
    [self.userdefaults synchronize];
}

#pragma mark - Geofences

- (void)storeRegions:(NSArray *)regions
{
    [self.userdefaults archiveObject:regions forKey:ORCListRegions];
    [self.userdefaults synchronize];
}

- (NSArray *)loadRegions
{
    return [self.userdefaults unarchiveObjectForKey:ORCListRegions];
}



@end
