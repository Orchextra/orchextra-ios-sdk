//
//  ORCWebViewViewController.m
//  Orchextra
//
//  Created by Judith Medina on 15/3/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCWebViewViewController.h"
#import "ORCWebViewPresenter.h"

NSString * const OBSERVER_JAVASCRIPT = @"OrchextraJSNativeiOS";

@interface ORCWebViewViewController ()
<WKNavigationDelegate, ORCWebViewInterface>

@property (strong, nonatomic) WKWebView *wkWebView;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@property (strong, nonatomic) ORCWebViewPresenter *presenter;

@end

@implementation ORCWebViewViewController

#pragma mark - INIT

- (instancetype)initWithPresenter:(ORCWebViewPresenter *)presenter
{
    self = [super init];
    
    if (self)
    {
        _presenter = presenter;
    }
    
    return self;
}

- (instancetype)initWithActionManager:(ORCActionManager *)actionManager
{
    ORCWebViewPresenter *presenter = [[ORCWebViewPresenter alloc] initWithActionManager:actionManager];
    presenter.viewController = self;
    return [self initWithPresenter:presenter];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeWebViewWithJavascript];
    [self initializeActivityIndicator];
    [self.presenter viewIsReady];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initializeWebViewWithJavascript
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    
    [userController addScriptMessageHandler:self name:OBSERVER_JAVASCRIPT];

    configuration.userContentController = userController;
    
    CGRect newFrame = self.view.frame;
    self.wkWebView = [[WKWebView alloc] initWithFrame:newFrame
                                        configuration:configuration];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.scrollView.bounces = NO;
    self.wkWebView.alpha = 0.0;
    [self.view addSubview:self.wkWebView];
}

- (void)initializeActivityIndicator
{
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.color = [UIColor lightGrayColor];
    self.spinner.center = self.view.center;
    [self.view addSubview:self.spinner];
}

#pragma mark - PUBLIC 

- (void)startWithURLString:(NSString *)urlString
{
    [self.presenter prepareURLWithString:urlString];
}

- (void)reloadURLString:(NSString *)urlString
{
    [self.presenter prepareURLWithString:urlString];
    [self.presenter reloadURLWithStringFromJS:urlString];
}

#pragma mark - DELEGATE (ORCWebViewInterface)

- (void)loadURLInCurrentWebView:(NSURL *)url
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.wkWebView loadRequest:request];
}

- (void)showSpinner
{
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
}

- (void)stopSpinner
{
    self.spinner.hidden = YES;
    [self.spinner stopAnimating];
}

#pragma mark - DELEGATE (WKScriptMessageHandler)

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    if([message.body isEqualToString:ORCSchemeScanner])
    {
        [self.presenter jsInvokeOpenScanner];
    }
    else if([message.body isEqualToString:ORCSchemeImageRecognition])
    {
        [self.presenter jsInvokeOpenImageRecognition];
    }
    else if([message.body isEqualToString:ORCHEXTRA_TO_LOADURL])
    {
        NSString *urlFromJS = @"";
        [self.presenter reloadURLWithStringFromJS:urlFromJS];
    }
}

#pragma mark - DELEGATE (WKWebNavigation)

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.presenter urlHasBeenLoadedSuccessfully:YES];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.wkWebView.alpha = 1.0;
    } completion:^(BOOL finished) {

    }];
    
    [[ORCLog sharedInstance] logDebug:@"Finished loading"];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self.presenter urlHasBeenLoadedSuccessfully:NO];
    [[ORCLog sharedInstance] logError:[NSString stringWithFormat: @"Error loading: %@", error.localizedDescription]];
}


@end

