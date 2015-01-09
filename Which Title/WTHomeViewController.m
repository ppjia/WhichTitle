//
//  ViewController.m
//  Which Title
//
//  Created by ray on 7/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#import "WTHomeViewController.h"
#import "WTNewsManager.h"
#import "WTNewsItem.h"
#import "WTGameQuestionPage.h"
#import "WTUtil.h"
#import "WTGameViewController.h"

@interface WTHomeViewController ()

@property (nonatomic, weak) IBOutlet UIView *startView;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UILabel *loadingLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) WTNews *news;

- (IBAction)didPressStartButton:(id)sender;

@end

@implementation WTHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityIndicator startAnimating];
    
    // load game contents
    [[WTNewsManager sharedManager] loadNews:^(WTNews *news, BOOL success) {
        
        // load successfully
        if (success && news.items.count > 0) {
            
            // pre-load the first image to avoid latency
            __block typeof(self) unretainedSelf = self;
            WTNewsItem *item = [news.items firstObject];
            [WTUtil loadImage:item.imageUrl withCompletionBlock:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [unretainedSelf revealStartPage];
                });
            }];
            
            self.news = news;
        }
        
        // load failed
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, the game cannot be loaded, please check your network connection!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void)revealStartPage
{
    self.activityIndicator.hidden = YES;
    self.loadingLabel.hidden = YES;
    self.startButton.hidden = NO;
}

#pragma mark - actions

- (void)didPressStartButton:(id)sender
{
    UIViewController *vc = [[WTGameViewController alloc] initWithNews:self.news];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
