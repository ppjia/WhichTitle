//
//  WTGamePage.m
//  Which Title
//
//  Created by ray on 7/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#define kScorePerQuestion 10
#define kTimeAllowedInSecond 10
#define kDeductScoreForEachSecondPassed 1
#define kDeductScoreForIncorrectAnswer 2

#import "WTGameQuestionPage.h"
#import "WTIndicatorView.h"
#import "WTUtil.h"

@interface WTGameQuestionPage()

@property (nonatomic, strong) WTNewsItem *item;
@property (nonatomic, strong) NSTimer *timer;
@property (atomic) NSInteger score;
@property (atomic) NSInteger secondsPassed;
@property (nonatomic) BOOL isIncorrectOnce;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *sectionLabel;
@property (atomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet UIView *indicatorView;
@property (nonatomic, weak) IBOutlet UIButton *answerButton1;
@property (nonatomic, weak) IBOutlet UIButton *answerButton2;
@property (nonatomic, weak) IBOutlet UIButton *answerButton3;
@property (nonatomic, weak) IBOutlet UIButton *giveupButton;


- (IBAction)didPressGiveupButton:(id)sender;
- (IBAction)didPressAnswer1:(id)sender;
- (IBAction)didPressAnswer2:(id)sender;
- (IBAction)didPressAnswer3:(id)sender;

@end

@implementation WTGameQuestionPage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.sectionLabel.clipsToBounds = YES;
    self.sectionLabel.layer.cornerRadius = 2.f;
}

#pragma mark - public methods

- (void)setupWithNewsItem:(WTNewsItem *)item
{
    self.score = kScorePerQuestion;
    self.isIncorrectOnce = NO;
    self.secondsPassed = 0;
    [self refreshScoreView];
    
    self.item = item;
    self.sectionLabel.text = self.item.section;
    self.imageView.image = [[WTUtil wtCache] objectForKey:item.imageUrl];
    [self.answerButton1 setTitle:[item.headlines objectAtIndex:0] forState:UIControlStateNormal];
    [self.answerButton2 setTitle:[item.headlines objectAtIndex:1] forState:UIControlStateNormal];
    [self.answerButton3 setTitle:[item.headlines objectAtIndex:2] forState:UIControlStateNormal];
}

- (void)startQuestion
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(oneSecondPassed) userInfo:nil repeats:YES];
    
    // start time indicator
    [(WTIndicatorView *)self.indicatorView animateInTime:kTimeAllowedInSecond];
}

#pragma mark - private methods

- (void)deductScore:(NSInteger)scoreToBeDeducted
{
    @synchronized(self) {
        self.score-=scoreToBeDeducted;
        [self refreshScoreView];
    }
}

- (void)answerCorrectly:(BOOL)isCorrect
{
    if (isCorrect) {
        [self.timer invalidate];
        self.item.score = (self.score>=0)?self.score:0;
        [self.delegate handleAnsweredItem:self.item];
    }
    
    // for first incorrect answer, deduct 2 score
    else {
        if (!self.isIncorrectOnce) {
            [self deductScore:kDeductScoreForIncorrectAnswer];
            self.isIncorrectOnce = YES;
        }
        
    }
}

- (void)oneSecondPassed
{
    self.secondsPassed++;
    
    // time expired
    if (self.secondsPassed >= kTimeAllowedInSecond) {
        self.item.score = 0;
        [self.timer invalidate];
        [self.delegate handleAnsweredItem:self.item];
    }
    
    // one second passed, deduct one score
    else {
        [self deductScore:kDeductScoreForEachSecondPassed];
    }
}

- (void)refreshScoreView
{
    NSString *labelText = [NSString stringWithFormat:@"+%ld points coming your way!", (self.score<0)?0:self.score];
    [self.scoreLabel setAttributedText:[WTUtil attributedText:labelText withRange:NSMakeRange(1, 2) withRegularFontSize:17 withBoldFontSize:24]];
}

- (void)glowButton:(UIButton *)button
{
    [UIView animateWithDuration:.2f
                          delay:0.f
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         button.alpha = .2f;
                         button.backgroundColor = [UIColor redColor];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:.2f
                                               delay:0.f
                                             options:UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              button.alpha = 1.f;
                                              button.backgroundColor = [UIColor whiteColor];
                                          }
                                          completion:nil];
                     }];
}

#pragma mark - actions

- (void)didPressAnswer1:(id)sender
{
    BOOL isCorrect = self.item.correctAnswerIndex == 0;
    [self answerCorrectly:isCorrect];
    if (!isCorrect) {
        [self glowButton:self.answerButton1];
    }
}

- (void)didPressAnswer2:(id)sender
{
    BOOL isCorrect = self.item.correctAnswerIndex == 1;
    [self answerCorrectly:isCorrect];
    if (!isCorrect) {
        [self glowButton:self.answerButton2];
    }
}

- (void)didPressAnswer3:(id)sender
{
    BOOL isCorrect = self.item.correctAnswerIndex == 2;
    [self answerCorrectly:isCorrect];
    if (!isCorrect) {
        [self glowButton:self.answerButton3];
    }
}

- (void)didPressGiveupButton:(id)sender
{
    [self.timer invalidate];
    [self.delegate handleGiveupItem:self.item];
}

@end
