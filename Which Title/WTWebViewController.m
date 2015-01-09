//
//  WTWebViewController.m
//  Which Title
//
//  Created by ray on 8/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#import "WTWebViewController.h"

@interface WTWebViewController ()<UIWebViewDelegate>

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIWebView *webView;

@end

@implementation WTWebViewController

- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    
    if (self) {
        
        // init web view, auto resize to fit when rotation
        CGRect frame = self.view.bounds;
        frame.origin.y = 0.0f;
        _webView = [[UIWebView alloc] initWithFrame:frame];
        _webView.delegate = self;
        [self.view addSubview:_webView];
        _webView.scalesPageToFit = YES;
        _webView.autoresizesSubviews = YES;
        _webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        
        //init activity indicator for content retrieving
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGSize size = self.view.frame.size;
        self.activityIndicator.frame = CGRectMake(size.width/2, size.height/2, 24, 24);
        [self.view addSubview:self.activityIndicator];
        
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didPressCancel)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - actions

- (void)didPressCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self.activityIndicator startAnimating];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.activityIndicator stopAnimating];
    
    // error code -999 occurs sometimes, but the pages are all loaded successfully, so just ignore it here
    if (error.code != -999) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                         message:@"Problems on the page loading..."
                                                        delegate:nil
                                               cancelButtonTitle:@"Ignore"
                                               otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
