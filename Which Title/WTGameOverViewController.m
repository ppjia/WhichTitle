//
//  WTGameOverViewController.m
//  Which Title
//
//  Created by ray on 8/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#import "WTGameOverViewController.h"
#import "WTGameViewController.h"
#import "WTUtil.h"
#import "WTNewsItem.h"

@interface WTGameOverViewController ()

@property (nonatomic, weak) IBOutlet UILabel *totalScoreLabel;

@property (nonatomic, strong) WTNews *news;
@property (nonatomic) NSInteger totalScore;

- (IBAction)didPressPlayButton:(id)sender;

@end

@implementation WTGameOverViewController

- (instancetype)initWithTotalScore:(NSInteger)totalScore withNews:(WTNews *)news
{
    self = [super init];
    if (self) {
        self.totalScore = totalScore;
        self.news = news;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.totalScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.totalScore];
    WTNewsItem *item = [self.news.items firstObject];
    [WTUtil loadImage:item.imageUrl withCompletionBlock:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - actions

- (void)didPressPlayButton:(id)sender
{
    WTGameViewController *vc = [[WTGameViewController alloc] initWithNews:self.news];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
