//
//  GIGURLManager.m
//  gignetwork
//
//  Created by Judith Medina Gonzalez on 18/3/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLManager.h"

#import "ORCGIGConstants.h"
#import "ORCGIGURLStorage.h"
#import "ORCGIGURLDomainsKeeper.h"
#import "ORCGIGURLConfigTableViewController.h"
#import "ORCGIGURLFixturesKeeper.h"


NSString * const ORCGIGURLDomainsDefaultFile = @"domains.json";
NSString * const ORCGIGURLManagerDidChangeCurrentDomainNotification = @"ORCGIGURLManagerDidChangeCurrentDomainNotification";
NSString * const ORCGIGURLManagerDidChangeDomainsNotification = @"ORCGIGURLManagerDidChangeDomainsNotification";
NSString * const ORCGIGURLManagerDomainUserInfoKey = @"ORCGIGURLManagerDomainUserInfoKey";

NSString * const ORCGIGURLFixturesDefaultFile = @"fixtures.json";
NSString * const ORCGIGURLManagerDidChangeFixtureNotification = @"ORCGIGURLManagerDidChangeFixtureNotification";
NSString * const ORCGIGURLManagerFixtureUserInfoKey = @"ORCGIGURLManagerFixtureUserInfoKey";


@interface ORCGIGURLManager ()

@property (strong, nonatomic) ORCGIGURLDomainsKeeper *domainsKeeper;
@property (strong, nonatomic) ORCGIGURLFixturesKeeper *fixturesKeeper;
@property (strong, nonatomic) NSNotificationCenter *notificationCenter;

@end


@implementation ORCGIGURLManager

+ (instancetype)sharedManager
{
    static ORCGIGURLManager *sharedInstance = nil;
    static dispatch_once_t sharedManager;
    
    dispatch_once(&sharedManager, ^{
        sharedInstance = [[ORCGIGURLManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    ORCGIGURLStorage *storage = [[ORCGIGURLStorage alloc] init];
    ORCGIGURLDomainsKeeper *domainsKeeper = [[ORCGIGURLDomainsKeeper alloc] initWithStorage:storage];
    ORCGIGURLFixturesKeeper *fixturesKeeper = [[ORCGIGURLFixturesKeeper alloc] initWithStorage:storage];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    return [self initWithDomainsKeeper:domainsKeeper fixturesKeeper:fixturesKeeper notificationCenter:notificationCenter];
}

- (instancetype)initWithDomainsKeeper:(ORCGIGURLDomainsKeeper *)domainsKeeper
                       fixturesKeeper:(ORCGIGURLFixturesKeeper *)fixturesKeeper
                   notificationCenter:(NSNotificationCenter *)notificationCenter
{
    self = [super init];
    if (self)
    {
        _fixturesKeeper = fixturesKeeper;
        _domainsKeeper = domainsKeeper;
        _notificationCenter = notificationCenter;
    }
    return self;
}

#pragma mark - ACCESSORS (Fixture)

- (BOOL)useFixture
{
    return self.fixturesKeeper.useFixture;
}

- (void)setUseFixture:(BOOL)useFixture
{
    self.fixturesKeeper.useFixture = useFixture;
}

- (ORCGIGURLFixture *)fixture
{
    return self.fixturesKeeper.currentFixture;
}

- (void)setFixture:(ORCGIGURLFixture *)fixture
{
    if ([fixture isEqualToFixture:self.fixture]) return;
    
    self.fixturesKeeper.currentFixture = fixture;
    [self notifyFixtureChange];
}

- (NSArray *)fixtures
{
    return self.fixturesKeeper.fixtures;
}

- (void)setFixtures:(NSArray *)fixtures
{
    if ([fixtures isEqualToArray:self.fixtures]) return;
    
    self.fixturesKeeper.fixtures = fixtures;
}

#pragma mark - ACCESSORS (Domain)

- (ORCGIGURLDomain *)domain
{
    return self.domainsKeeper.currentDomain;
}

- (void)setDomain:(ORCGIGURLDomain *)domain
{
    if ([domain isEqualToDomain:self.domain]) return;
    
    self.domainsKeeper.currentDomain = domain;
    [self notifyDomainChange];
}

- (NSArray *)domains
{
    return self.domainsKeeper.domains;
}

- (void)setDomains:(NSArray *)domains
{
    self.domainsKeeper.domains = domains;
}

#pragma mark - PUBLIC

- (NSData *)fixtureForRequestTag:(NSString *)requestTag
{
    return [self.fixturesKeeper mockForRequestTag:requestTag];
}

- (void)showConfig
{
    UIViewController *topViewController = [self topViewController];
    if (topViewController != nil)
    {
        ORCGIGURLConfigTableViewController *config = [[ORCGIGURLConfigTableViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:config];
    
        [topViewController presentViewController:navController animated:YES completion:nil];
    }
}

- (void)loadFixturesFile:(NSString *)fixturesFilename
{
    [self.fixturesKeeper loadFixturesFromFile:fixturesFilename];
}

- (void)loadDomainsFile:(NSString *)domainsFilename
{
    [self.domainsKeeper loadDomainsFromFilename:domainsFilename];
}

- (void)addDomain:(ORCGIGURLDomain *)domain
{
    [self.domainsKeeper addDomain:domain];    
    [self notifyDomainsEdit];
}

- (void)removeDomain:(ORCGIGURLDomain *)domain
{
    [self.domainsKeeper removeDomain:domain];
    [self notifyDomainsEdit];
}

- (void)moveDomain:(ORCGIGURLDomain *)domain toIndex:(NSInteger)destinationIndex
{
    [self.domainsKeeper moveDomain:domain toIndex:destinationIndex];
    [self notifyDomainsEdit];
}

- (void)updateDomain:(ORCGIGURLDomain *)domain withDomain:(ORCGIGURLDomain *)newDomain;
{
    [self.domainsKeeper replaceDomain:domain withDomain:newDomain];
    [self notifyDomainsEdit];
}

#pragma mark - PRIVATE

- (void)notifyDomainChange
{
    NSDictionary *userInfo = @{ORCGIGURLManagerDomainUserInfoKey: self.domain};
    [self.notificationCenter postNotificationName:ORCGIGURLManagerDidChangeCurrentDomainNotification object:self userInfo:userInfo];
}

- (void)notifyDomainsEdit
{
    [self.notificationCenter postNotificationName:ORCGIGURLManagerDidChangeDomainsNotification object:self userInfo:nil];
}

- (void)notifyFixtureChange
{
    NSDictionary *userInfo = @{ORCGIGURLManagerFixtureUserInfoKey: self.fixture};
    [self.notificationCenter postNotificationName:ORCGIGURLManagerDidChangeFixtureNotification object:self userInfo:userInfo];
}

- (UIViewController *)topViewController
{
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topViewController.presentedViewController)
    {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([topViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navController = (UINavigationController *)topViewController;
        UIViewController *firstViewController = navController.viewControllers[0];
        
        if ([firstViewController isKindOfClass:[ORCGIGURLConfigTableViewController class]])
        {
            topViewController = nil;
        }
    }
    
    return topViewController;
}

@end
