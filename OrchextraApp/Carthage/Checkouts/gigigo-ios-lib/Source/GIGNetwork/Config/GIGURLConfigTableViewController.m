//
//  GIGURLConfigTableViewController.m
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLConfigTableViewController.h"

#import "GIGURLManager.h"
#import "GIGURLConfigDomainsTableViewController.h"
#import "GIGURLConfigFixturesTableViewController.h"


NSInteger const GIGURLConfigDomainRow = 0;
NSInteger const GIGURLConfigFixtureRow = 1;
NSInteger const GIGURLConfigNumberOfRows = 2;
NSString * const GIGConfigTitle = @"Config";
NSString * const GIGDomainTitle = @"Domain";
NSString * const GIGFixtureTitle = @"Fixtures";


@interface GIGURLConfigTableViewController ()

@property (strong, nonatomic) GIGURLManager *manager;
@property (strong, nonatomic) NSNotificationCenter *notificationCenter;

@end


@implementation GIGURLConfigTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = GIGConfigTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapDone)];
    
    self.manager = [GIGURLManager sharedManager];
    self.notificationCenter = [NSNotificationCenter defaultCenter];
    
    [self.notificationCenter addObserver:self selector:@selector(didChangeDomainNotification:) name:GIGURLManagerDidChangeCurrentDomainNotification object:nil];
    [self.notificationCenter addObserver:self selector:@selector(didChangeFixtureNotification:) name:GIGURLManagerDidChangeFixtureNotification object:nil];
}

- (void)dealloc
{
    [self.notificationCenter removeObserver:self];
}

#pragma mark - ACTIONS

- (void)tapDone
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NOTIFICATIONS

- (void)didChangeDomainNotification:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)didChangeFixtureNotification:(NSNotification *)notification
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return GIGURLConfigNumberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"config_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    switch (indexPath.row) {
        case GIGURLConfigDomainRow:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = GIGDomainTitle;
            cell.detailTextLabel.text = self.manager.domain.name;
        }
            break;
        case GIGURLConfigFixtureRow:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = GIGFixtureTitle;
            cell.detailTextLabel.text = self.manager.fixture.name;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case GIGURLConfigDomainRow:
        {
            GIGURLConfigDomainsTableViewController *configDomains = [[GIGURLConfigDomainsTableViewController alloc] init];
            [self.navigationController pushViewController:configDomains animated:YES];
        }
            break;
        case GIGURLConfigFixtureRow:
        {
            GIGURLConfigFixturesTableViewController *configFixtures = [[GIGURLConfigFixturesTableViewController alloc] init];
            [self.navigationController pushViewController:configFixtures animated:YES];
        }
            
        default:
            break;
    }
}

@end
