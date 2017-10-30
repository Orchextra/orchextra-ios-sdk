//
//  GIGURLConfigDomainsTableViewController.m
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLConfigDomainsTableViewController.h"

#import "GIGURLManager.h"
#import "GIGURLConfigAddDomainViewController.h"


@interface GIGURLConfigDomainsTableViewController ()

@property (strong, nonatomic) GIGURLManager *manager;
@property (strong, nonatomic) NSNotificationCenter *notificationCenter;

@property (strong, nonatomic) NSMutableArray *domains;

@end


@implementation GIGURLConfigDomainsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title =  NSLocalizedString(@"Domains", nil);
    [self displayNormalLayout];
    
    self.manager = [GIGURLManager sharedManager];
    self.notificationCenter = [NSNotificationCenter defaultCenter];
    self.domains = [self.manager.domains mutableCopy];
    
    [self.notificationCenter addObserver:self selector:@selector(domainsDidChangeNotification:) name:GIGURLManagerDidChangeCurrentDomainNotification object:nil];
    [self.notificationCenter addObserver:self selector:@selector(domainsDidEditNotification:) name:GIGURLManagerDidChangeDomainsNotification object:nil];
}

- (void)dealloc
{
    [self.notificationCenter removeObserver:self];
}

#pragma mark - ACTIONS

- (void)tapEditButton
{
    [self displayEditLayout];
}

- (void)tapDoneButton
{
    [self displayNormalLayout];
}

- (void)tapAddButton
{
    GIGURLConfigAddDomainViewController *addDomain = [[GIGURLConfigAddDomainViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addDomain];
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

#pragma mark - NOTIFICATIONS

- (void)domainsDidChangeNotification:(NSNotification *)notification
{
    self.domains = [self.manager.domains mutableCopy];
    
    [self.tableView reloadData];
}

- (void)domainsDidEditNotification:(NSNotification *)notification
{
    if (self.manager.domains.count > self.domains.count)
    {
        self.domains = [self.manager.domains mutableCopy];
        
        [self.tableView reloadData];
    }
}

#pragma mark - PRIVATE

- (void)displayNormalLayout
{
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(tapEditButton)];
    
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    
    [self setEditing:NO animated:YES];
}

- (void)displayEditLayout
{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(tapAddButton)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapDoneButton)];
    
    [self.navigationItem setLeftBarButtonItem:addButton animated:YES];
    [self.navigationItem setRightBarButtonItem:doneButton animated:YES];
    
    [self setEditing:YES animated:YES];
}

- (void)deleteDomainAtIndexPath:(NSIndexPath *)indexPath
{
    GIGURLDomain *domain = self.domains[indexPath.row];
    [self.manager removeDomain:domain];
    
    [self.domains removeObject:domain];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)editDomainAtIndexPath:(NSIndexPath *)indexPath
{
    GIGURLDomain *domain = self.domains[indexPath.row];
    
    GIGURLConfigAddDomainViewController *addDomain = [[GIGURLConfigAddDomainViewController alloc] init];
    addDomain.domain = domain;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addDomain];
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

- (BOOL)isCurrentDomain:(GIGURLDomain *)domain
{
    return [domain isEqualToDomain:self.manager.domain];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.domains.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"domain_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    GIGURLDomain *domain = self.domains[indexPath.row];
    cell.textLabel.text = domain.name;
    cell.detailTextLabel.text = domain.url;
    
    cell.accessoryType = ([domain isEqualToDomain:self.manager.domain]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GIGURLDomain *domain = self.domains[indexPath.row];
    
    return ([self isCurrentDomain:domain]) ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deleteDomainAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    GIGURLDomain *domainToMove = self.domains[sourceIndexPath.row];
    [self.domains removeObject:domainToMove];
    [self.domains insertObject:domainToMove atIndex:destinationIndexPath.row];
    
    [self.manager moveDomain:domainToMove toIndex:destinationIndexPath.row];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GIGURLDomain *selectedDomain = self.domains[indexPath.row];
    if (![self.manager.domain isEqualToDomain:selectedDomain])
    {
        self.manager.domain = selectedDomain;
        
        [tableView reloadData];
    }
}

@end
