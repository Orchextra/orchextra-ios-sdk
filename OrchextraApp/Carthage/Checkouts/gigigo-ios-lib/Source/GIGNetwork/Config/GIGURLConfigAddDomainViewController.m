//
//  GIGURLConfigAddDomainViewController.m
//  gignetwork
//
//  Created by Sergio Baró on 07/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLConfigAddDomainViewController.h"

#import "GIGURLManager.h"
#import "GIGURLFormatter.h"
#import "GIGLayout.h"


@interface GIGURLConfigAddDomainViewController ()
<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *nameField;
@property (strong, nonatomic) UITextField *urlField;
@property (strong, nonatomic) UISegmentedControl *protocolSelector;

@property (strong, nonatomic) NSArray *protocols;
@property (strong, nonatomic) GIGURLManager *manager;
@property (strong, nonatomic) GIGURLFormatter *urlFormatter;

@end


@implementation GIGURLConfigAddDomainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = (self.domain != nil) ? NSLocalizedString(@"Edit Domain", nil) : NSLocalizedString(@"Add Domain", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(tapSaveButton)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(tapCancelButton)];
    
    [self addNameField];
    [self addUrlField];
    [self addProtocolSelector];
    
    self.urlFormatter = [[GIGURLFormatter alloc] init];
    self.manager = [GIGURLManager sharedManager];
    
    self.navigationItem.rightBarButtonItem.enabled = [self textAreValid];
    [self addCurrentProtocol];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.nameField becomeFirstResponder];
}

#pragma mark - ACTIONS

- (void)tapSaveButton
{
    [self saveDomainAndDismiss];
}

- (void)tapCancelButton
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapProtocolSelector
{
    [self addCurrentProtocol];
}

#pragma mark - PRIVATE

- (void)addCurrentProtocol
{
    NSString *protocol = self.protocols[self.protocolSelector.selectedSegmentIndex];
    self.urlField.text = [self.urlFormatter formatUrl:self.urlField.text withProtocol:protocol];
}

- (BOOL)textAreValid
{
    return (self.nameField.text.length > 0 && self.urlField.text > 0);
}

- (void)saveDomainAndDismiss
{
    NSString *name = self.nameField.text;
    NSString *url = self.urlField.text;
    
    GIGURLDomain *newDomain = [[GIGURLDomain alloc] initWithName:name url:url];
    
    if (self.domain != nil)
    {
        [self.manager updateDomain:self.domain withDomain:newDomain];
    }
    else
    {
        [self.manager addDomain:newDomain];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameField)
    {
        [self.urlField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        
        if ([self textAreValid])
        {
            [self saveDomainAndDismiss];
        }
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.navigationItem.rightBarButtonItem.enabled = [self textAreValid];
    
    return YES;
}

#pragma mark - HELPERS

- (void)addNameField
{
    self.nameField = [self textFieldWithPlaceholder:NSLocalizedString(@"name", nil) returnKey:UIReturnKeyNext];
    self.nameField.text = self.domain.name;
    
    [self.view addSubview:self.nameField];
    
    gig_layout_left(self.nameField, 20);
    gig_layout_right(self.nameField, 20);
    gig_layout_top(self.nameField, 10);
}

- (void)addUrlField
{
    self.urlField = [self textFieldWithPlaceholder:NSLocalizedString(@"url", nil) returnKey:UIReturnKeyGo];
    self.urlField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.urlField.text = self.domain.url;
    
    [self.view addSubview:self.urlField];
    
    gig_layout_left(self.urlField, 20);
    gig_layout_right(self.urlField, 20);
    gig_layout_below(self.urlField, self.nameField, 10);
}

- (void)addProtocolSelector
{
    self.protocols = @[@"http", @"https"];
    
    self.protocolSelector = [[UISegmentedControl alloc] initWithItems:self.protocols];
    self.protocolSelector.selectedSegmentIndex = 0;
    [self.protocolSelector addTarget:self action:@selector(tapProtocolSelector) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.protocolSelector];
    
    gig_autoresize(self.protocolSelector, NO);
    gig_layout_center_horizontal(self.protocolSelector, 0);
    gig_layout_below(self.protocolSelector, self.urlField, 10);
}

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder returnKey:(UIReturnKeyType)returnKey
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 64, self.view.frame.size.width - 20, 30)];
    textField.borderStyle = UITextBorderStyleLine;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.enablesReturnKeyAutomatically = YES;
    textField.delegate = self;
    
    textField.placeholder = placeholder;
    textField.returnKeyType = returnKey;
    
    gig_autoresize(textField, NO);
    gig_constrain_height(textField, 30);
    
    return textField;
}

@end
