//
//  GLAMultiRequestViewController.m
//  GIGLibrary
//
//  Created by Sergio Baró on 30/09/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GLAMultiRequestViewController.h"
#import "GIGURLCommunicator.h"
#import "GIGURLManager.h"


@interface GLAMultiRequestViewController ()

@property (strong, nonatomic) GIGURLCommunicator *communicator;

@end


@implementation GLAMultiRequestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.communicator = [[GIGURLCommunicator alloc] init];
}

#pragma mark - ACTIONS

- (IBAction)tapMultirequestButton
{
    GIGURLManager *manager = [GIGURLManager sharedManager];
    manager.fixture = manager.fixtures[1];
    manager.useFixture = YES;
    
    GIGURLRequest *request = [self.communicator GET:@"http://www.gigigo.com"];
    request.requestTag = @"config";
    
    NSLog(@"%@", request);
    
    NSDictionary *requests = @{request.requestTag: request};
    
    [self.communicator sendRequests:requests completion:^(NSDictionary *responses) {
        NSLog(@"responses: %@", responses);
    }];
}

@end
