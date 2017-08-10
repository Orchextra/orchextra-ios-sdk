//
//  GIGURLConfigTableViewController.m
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLConfigTableViewController.h"

#import "ORCGIGURLManager.h"
#import "ORCGIGURLConfigDomainsTableViewController.h"
#import "ORCGIGURLConfigFixturesTableViewController.h"


NSInteger const ORCGIGURLConfigDomainRow = 0;
NSInteger const ORCGIGURLConfigFixtureRow = 1;
NSInteger const ORCGIGURLConfigNumberOfRows = 2;

// Visual Constants
static NSString * const kConfigTitle = @"Config";
static NSString * const kDomains = @"Domains";
static NSString * const kFixtures = @"Fixtures";

@interface ORCGIGURLConfigTableViewController ()

@property (strong, nonatomic) ORCGIGURLManager *manager;
@property (strong, nonatomic) NSNotificationCenter *notificationCenter;

@end


@implementation ORCGIGURLConfigTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = kConfigTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapDone)];
    
    self.manager = [ORCGIGURLManager sharedManager];
    self.notificationCenter = [NSNotificationCenter defaultCenter];
    
    [self.notificationCenter addObserver:self selector:@selector(didChangeDomainNotification:) name:ORCGIGURLManagerDidChangeCurrentDomainNotification object:nil];
    [self.notificationCenter addObserver:self selector:@selector(didChangeFixtureNotification:) name:ORCGIGURLManagerDidChangeFixtureNotification object:nil];
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
    return ORCGIGURLConfigNumberOfRows;
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
        case ORCGIGURLConfigDomainRow:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = kDomains;
            cell.detailTextLabel.text = self.manager.domain.name;
        }
            break;
        case ORCGIGURLConfigFixtureRow:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = kFixtures;
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
        case ORCGIGURLConfigDomainRow:
        {
            ORCGIGURLConfigDomainsTableViewController *configDomains = [[ORCGIGURLConfigDomainsTableViewController alloc] init];
            [self.navigationController pushViewController:configDomains animated:YES];
        }
            break;
        case ORCGIGURLConfigFixtureRow:
        {
            ORCGIGURLConfigFixturesTableViewController *configFixtures = [[ORCGIGURLConfigFixturesTableViewController alloc] init];
            [self.navigationController pushViewController:configFixtures animated:YES];
        }
            
        default:
            break;
    }
}

@end
