//
//  ORCWebViewController.m
//  Orchestra
//
//  Created by Judith Medina on 30/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <PassKit/PassKit.h>

#import "ORCWebViewController.h"
#import "ORCBarButtonItem.h"
#import "ORCSettingsPersister.h"
#import "ORCGIGLayout.h"
#import "ORCThemeSdk.h"
#import "NSBundle+ORCBundle.h"
#import "UIImage+ORCGIGExtension.h"

CGFloat const HEIGHT_TOOLBAR = 44;


@interface ORCWebViewController()
<UIWebViewDelegate>

@property (strong, nonatomic) ORCSettingsPersister *storage;
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSURLRequest *lastRequest;

@end

@implementation ORCWebViewController


#pragma mark - LIFECYCLE

- (instancetype)initWithURLString:(NSString *)urlString
{
    self = [super init];
    
    if (self)
    {
        _url = [NSURL URLWithString:urlString];
        _storage = [[ORCSettingsPersister alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - ACTIONS

- (void)cancelButtonTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goBackWebView
{
    [self.webView goBack];
}

- (void)goForwardWebView
{
    [self.webView goForward];
}

- (void)reloadWebView
{
    [self.webView reload];
}

#pragma mark - PRIVATE

- (void)initialize
{
    self.title =  LocalizableConstants.kLocaleOrcBrowserTitle;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:self action:@selector(cancelButtonTapped)];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.webView];
    gig_layout_fit(self.webView);
    
    self.toolBar = [[UIToolbar alloc] init];
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    // Back button
    UIImage *previousImg = [NSBundle imageFromBundleWithName:@"previous-grey"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:previousImg forState:UIControlStateNormal];
    [backButton setBounds:CGRectMake(0, 0, previousImg.size.width, previousImg.size.height)];
    [backButton addTarget:self action:@selector(goBackWebView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [items addObject:backBarButton];
    
    // Forward button
    UIImage *nextImg = [NSBundle imageFromBundleWithName:@"next-grey"];
    
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forwardButton setImage:nextImg forState:UIControlStateNormal];
    [forwardButton setBounds:CGRectMake(0, 0, nextImg.size.width, nextImg.size.height)];
    [forwardButton addTarget:self action:@selector(goForwardWebView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *forwardBarButton = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
    [items addObject:forwardBarButton];
    
    // Flexible Space
    [items addObject:[[UIBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                      target:nil action:nil]];
    
    // Refresh button
    [items addObject:[[UIBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                      target:self action:@selector(reloadWebView)]];
    [self.toolBar setItems:items];
    [self.view addSubview:self.toolBar];
    
    gig_layout_bottom(self.toolBar, 0);
    gig_constrain_height(self.toolBar, HEIGHT_TOOLBAR);
    
    NSArray *constraintWidth = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"|[toolBar]|"
                                options:0
                                metrics:nil
                                views:@{@"toolBar" : self.toolBar}];
    [self.view addConstraints:constraintWidth];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    self.lastRequest = request;
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:_lastRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if ([response.MIMEType isEqualToString:@"application/vnd.apple.pkpass"]) {
            NSError *error;
            PKPass *pass = [[PKPass alloc] initWithData:data error:&error];
            if (error) {
                [[ORCLog sharedInstance] logError:@"Error: %@", error];
            } else {
                PKAddPassesViewController *apvc = [[PKAddPassesViewController alloc] initWithPass:pass];
                [self presentViewController:apvc animated:YES completion:nil];
            }
        }
    }];
}

@end
