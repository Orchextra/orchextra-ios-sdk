//
//  GIGURLConfigFixturesTableViewController.m
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLConfigFixturesTableViewController.h"

#import "ORCGIGURLManager.h"
#import "ORCGIGURLConfigFixtureDetailTableViewController.h"

// Visual Constants
static NSString * const kFixtures = @"Fixtures";

@interface ORCGIGURLConfigFixturesTableViewController ()

@property (strong, nonatomic) ORCGIGURLManager *manager;
@property (strong, nonatomic) NSNotificationCenter *notificationCenter;

@end


@implementation ORCGIGURLConfigFixturesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = kFixtures;
    
    self.manager = [ORCGIGURLManager sharedManager];
    self.notificationCenter = [NSNotificationCenter defaultCenter];
    
    [self.notificationCenter addObserver:self selector:@selector(fixtureDidChangeNotification:) name:ORCGIGURLManagerDidChangeFixtureNotification object:nil];
}

- (void)dealloc
{
    [self.notificationCenter removeObserver:self];
}

#pragma mark - NOTIFICATIONS

- (void)fixtureDidChangeNotification:(NSNotification *)notification
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.manager.fixtures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"config_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    ORCGIGURLFixture *fixture = self.manager.fixtures[indexPath.row];
    cell.textLabel.text = fixture.name;
    cell.accessoryType = [fixture isEqualToFixture:self.manager.fixture] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ORCGIGURLConfigFixtureDetailTableViewController *fixtureDetail = [[ORCGIGURLConfigFixtureDetailTableViewController alloc] init];
    fixtureDetail.fixture = self.manager.fixtures[indexPath.row];
    
    [self.navigationController pushViewController:fixtureDetail animated:YES];
}

@end
