//
//  WTGameViewController.m
//  Which Title
//
//  Created by ray on 8/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#import "WTGameViewController.h"
#import "WTGameQuestionPage.h"
#import "WTGameAnswerPage.h"
#import "WTWebViewController.h"
#import "WTGameOverViewController.h"
#import "WTUtil.h"

@interface WTGameViewController ()<WTGameQuestionPageDelegate, WTGameAnswerPageDelegate>

@property (nonatomic, strong) WTNews *news;
@property (nonatomic) NSInteger questionIndex;
@property (nonatomic) NSInteger totalScore;

@property (nonatomic, strong) WTGameQuestionPage *gameQuestionPage;
@property (nonatomic, strong) WTGameAnswerPage *gameAnswerPage;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WTGameViewController

- (instancetype)initWithNews:(WTNews *)news
{
    self = [super init];
    if (self) {
        self.news = news;
        self.totalScore = 0;
        self.questionIndex = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    // prepare the first question page
    WTNewsItem *item = [self.news.items objectAtIndex:self.questionIndex];
    [self.gameQuestionPage setupWithNewsItem:item];
    
    // set backgroud
    [self refreshBackground];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self preloadNextImage];
    
    WTGameQuestionPage *page1 = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WTGameQuestionPage class]) owner:nil options:nil] firstObject];
    page1.delegate = self;
    
    WTGameAnswerPage *page2 = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WTGameAnswerPage class]) owner:nil options:nil] firstObject];
    page2.delegate = self;
    
    self.gameQuestionPage = page1;
    self.gameAnswerPage = page2;
    
    // assemble pages in scroll view
    [self addSubviews:@[page1, page2] toScrollView:self.scrollView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // start question
    [self.gameQuestionPage startQuestion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[WTUtil wtCache] removeAllObjects];
}


#pragma mark - private methods

- (void)moveToNextQuestion
{
    // remove the old image from cache to clear memory
    WTNewsItem *currentItem = [self.news.items objectAtIndex:self.questionIndex];
    [[WTUtil wtCache] removeObjectForKey:currentItem.imageUrl];
    
    self.questionIndex++;
    
    // no more questions, move to game over page
    if (self.news.items.count <= self.questionIndex) {
        WTGameOverViewController *vc = [[WTGameOverViewController alloc] initWithTotalScore:self.totalScore withNews:self.news];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    // load new question
    else {
        [self refreshBackground];
        [self.gameQuestionPage setupWithNewsItem:[self.news.items objectAtIndex:self.questionIndex]];
        [self.gameQuestionPage startQuestion];
        
        [self preloadNextImage];
    }
}

// preload the next story image ansynchronously
- (void)preloadNextImage
{
    // reach the last one
    if (self.news.items.count == self.questionIndex+1) {
        return;
    }
    WTNewsItem *nextItem = [self.news.items objectAtIndex:self.questionIndex+1];
    [WTUtil loadImage:nextItem.imageUrl withCompletionBlock:nil];
    
    // preload one more image if the item exists, just in case user keep hitting "skip" button
    if (self.news.items.count == self.questionIndex+2) {
        return;
    }
    WTNewsItem *furtherNextItem = [self.news.items objectAtIndex:self.questionIndex+2];
    [WTUtil loadImage:furtherNextItem.imageUrl withCompletionBlock:nil];
}

// add subviews to the scroll view
- (void)addSubviews:(NSArray *)subviews toScrollView:(UIScrollView *)scrollView
{
    CGSize pageSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat x = 0;
    
    for (UIView *subview in subviews) {
        subview.autoresizingMask = UIViewAutoresizingNone;
        
        subview.frame = CGRectMake(x,  0, pageSize.width, pageSize.height);
        
        x += pageSize.width;
        [scrollView addSubview:subview];
    }
    
    self.scrollView.contentSize = CGSizeMake(pageSize.width*subviews.count, CGRectGetHeight(scrollView.frame));
}

// set current story image to background and blur it
- (void)refreshBackground
{
    WTNewsItem *item = [self.news.items objectAtIndex:self.questionIndex];
    self.bgImageView.image = [[WTUtil wtCache] objectForKey:item.imageUrl];
    [WTUtil blurImageView:self.bgImageView];
}

#pragma mark - WTGameQuestionPageDelegate

- (void)handleAnsweredItem:(WTNewsItem *)theItem
{
    self.totalScore+=theItem.score;
    
    [self.gameAnswerPage setupWithNewsItem:theItem andTotalScore:self.totalScore];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.x = frame.size.width ;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)handleGiveupItem:(WTNewsItem *)theItem
{
    [self moveToNextQuestion];
}

#pragma mark - WTGameAnswerPageDelegate

- (void)handleReadArticle
{
    WTNewsItem *item = [self.news.items objectAtIndex:self.questionIndex];
    WTWebViewController *webVC = [[WTWebViewController alloc] initWithUrl:item.storyUrl];
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:webVC];
    webVC.title = [item.headlines objectAtIndex:item.correctAnswerIndex];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)handleNextQuestion
{
    // view scroll back to question page
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    [self moveToNextQuestion];
}

@end
