//
//  GIGURLConfigFixtureDetailTableViewController.m
//  gignetwork
//
//  Created by Sergio Baró on 07/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLConfigFixtureDetailTableViewController.h"

#import "GIGURLManager.h"


@interface GIGURLConfigFixtureDetailTableViewController ()

@property (strong, nonatomic) NSArray *mockKeys;
@property (strong, nonatomic) GIGURLManager *manager;

@end


@implementation GIGURLConfigFixtureDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.allowsSelection = NO;
    
    self.title = self.fixture.name;
    self.mockKeys = [self.fixture.mocks.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.manager = [GIGURLManager sharedManager];
    
    if (![self.fixture isEqualToFixture:self.manager.fixture])
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Set", nil)
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(tapSetFixture)];
    }
}

#pragma mark - ACTIONS

- (void)tapSetFixture
{
    self.manager.fixture = self.fixture;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mockKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"fixture_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
    }
    
    NSString *mockKey = self.mockKeys[indexPath.row];
    cell.textLabel.text = mockKey;
    cell.detailTextLabel.text = self.fixture.mocks[mockKey];
    
    return cell;
}

@end
