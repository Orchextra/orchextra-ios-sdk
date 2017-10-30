//
//  GLABasicFormViewController.m
//  GIGLibrary
//
//  Created by Sergio Baró on 19/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GLABasicFormViewController.h"

#import "GIGFormulary.h"


@interface GLABasicFormViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) GIGFormController *formController;

@end


@implementation GLABasicFormViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.formController = [[GIGFormController alloc] initWithParentView:self.view headerView:self.headerView footerView:self.footerView];
    [self.formController loadFieldsFromJSONFile:@"basic_form.json"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.formController becomeFirstResponder];
}

#pragma mark - Actions

- (IBAction)tapSendButton
{
    [self.formController resignFirstResponder];
    [self.formController validateFields];
}

@end
