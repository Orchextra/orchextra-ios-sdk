//
//  GIGURLManager.m
//  gignetwork
//
//  Created by Judith Medina Gonzalez on 18/3/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLManager.h"

#import "GIGConstants.h"
#import "GIGURLStorage.h"
#import "GIGURLDomainsKeeper.h"
#import "GIGURLConfigTableViewController.h"
#import "GIGURLFixturesKeeper.h"
#import "GIGURLRequest.h"


NSString * const GIGURLDomainsDefaultFile = @"domains.json";
NSString * const GIGURLManagerDidChangeCurrentDomainNotification = @"GIGURLManagerDidChangeCurrentDomainNotification";
NSString * const GIGURLManagerDidChangeDomainsNotification = @"GIGURLManagerDidChangeDomainsNotification";
NSString * const GIGURLManagerDomainUserInfoKey = @"GIGURLManagerDomainUserInfoKey";

NSString * const GIGURLFixturesDefaultFile = @"fixtures.json";
NSString * const GIGURLManagerDidChangeFixtureNotification = @"GIGURLManagerDidChangeFixtureNotification";
NSString * const GIGURLManagerFixtureUserInfoKey = @"GIGURLManagerFixtureUserInfoKey";


@interface GIGURLManager ()

@property (strong, nonatomic) GIGURLDomainsKeeper *domainsKeeper;
@property (strong, nonatomic) GIGURLFixturesKeeper *fixturesKeeper;
@property (strong, nonatomic) NSNotificationCenter *notificationCenter;

@end


@implementation GIGURLManager

+ (instancetype)sharedManager
{
    static GIGURLManager *sharedInstance = nil;
    static dispatch_once_t sharedManager;
    
    dispatch_once(&sharedManager, ^{
        sharedInstance = [[GIGURLManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    GIGURLStorage *storage = [[GIGURLStorage alloc] init];
    GIGURLDomainsKeeper *domainsKeeper = [[GIGURLDomainsKeeper alloc] initWithStorage:storage];
    GIGURLFixturesKeeper *fixturesKeeper = [[GIGURLFixturesKeeper alloc] initWithStorage:storage];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    return [self initWithDomainsKeeper:domainsKeeper fixturesKeeper:fixturesKeeper notificationCenter:notificationCenter];
}

- (instancetype)initWithDomainsKeeper:(GIGURLDomainsKeeper *)domainsKeeper
                       fixturesKeeper:(GIGURLFixturesKeeper *)fixturesKeeper
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

- (GIGURLFixture *)fixture
{
    return self.fixturesKeeper.currentFixture;
}

- (void)setFixture:(GIGURLFixture *)fixture
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

- (GIGURLDomain *)domain
{
    return self.domainsKeeper.currentDomain;
}

- (void)setDomain:(GIGURLDomain *)domain
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

- (void)showConfig
{
    UIViewController *topViewController = [self topViewController];
    if (topViewController != nil)
    {
        GIGURLConfigTableViewController *config = [[GIGURLConfigTableViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:config];
    
        [topViewController presentViewController:navController animated:YES completion:nil];
    }
}

- (BOOL)requestShouldUseMock:(GIGURLRequest *)request
{
    if ([self requestShouldUseRequestMock:request])
    {
        return YES;
    }
    
    return [self requestShouldUseFixtureMock:request];
}

- (NSData *)mockForRequest:(GIGURLRequest *)request
{
    if ([self requestShouldUseRequestMock:request])
    {
        return [self.fixturesKeeper mockWithFilename:request.mockFilename];
    }
    else if ([self requestShouldUseFixtureMock:request])
    {
        return [self.fixturesKeeper mockForRequestTag:request.requestTag];
    }
    
    return nil;
}

- (void)loadDomainsFile:(NSString *)domainsFilename
{
    [self.domainsKeeper loadDomainsFromFilename:domainsFilename];
}

- (void)addDomain:(GIGURLDomain *)domain
{
    [self.domainsKeeper addDomain:domain];    
    [self notifyDomainsEdit];
}

- (void)removeDomain:(GIGURLDomain *)domain
{
    [self.domainsKeeper removeDomain:domain];
    [self notifyDomainsEdit];
}

- (void)moveDomain:(GIGURLDomain *)domain toIndex:(NSInteger)destinationIndex
{
    [self.domainsKeeper moveDomain:domain toIndex:destinationIndex];
    [self notifyDomainsEdit];
}

- (void)updateDomain:(GIGURLDomain *)domain withDomain:(GIGURLDomain *)newDomain;
{
    [self.domainsKeeper replaceDomain:domain withDomain:newDomain];
    [self notifyDomainsEdit];
}

#pragma mark - PRIVATE

- (BOOL)requestShouldUseRequestMock:(GIGURLRequest *)request
{
    return (request.mockFilename.length > 0);
}

- (BOOL)requestShouldUseFixtureMock:(GIGURLRequest *)request
{
    return (self.useFixture && [self.fixturesKeeper isMockDefinedForRequestTag:request.requestTag]);
}

- (void)notifyDomainChange
{
    NSDictionary *userInfo = @{GIGURLManagerDomainUserInfoKey: self.domain};
    [self.notificationCenter postNotificationName:GIGURLManagerDidChangeCurrentDomainNotification object:self userInfo:userInfo];
}

- (void)notifyDomainsEdit
{
    [self.notificationCenter postNotificationName:GIGURLManagerDidChangeDomainsNotification object:self userInfo:nil];
}

- (void)notifyFixtureChange
{
    NSDictionary *userInfo = @{GIGURLManagerFixtureUserInfoKey: self.fixture};
    [self.notificationCenter postNotificationName:GIGURLManagerDidChangeFixtureNotification object:self userInfo:userInfo];
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
        
        if ([firstViewController isKindOfClass:[GIGURLConfigTableViewController class]])
        {
            topViewController = nil;
        }
    }
    
    return topViewController;
}

@end
