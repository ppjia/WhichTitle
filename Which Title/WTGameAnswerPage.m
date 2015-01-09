//
//  WTGameAnswerPage.m
//  Which Title
//
//  Created by ray on 8/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#import "WTGameAnswerPage.h"
#import "WTUtil.h"

@interface WTGameAnswerPage()

@property (nonatomic, weak) IBOutlet UIView *scoreView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;

@property (nonatomic, weak) IBOutlet UILabel *scoreLabel1;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel2;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel3;

- (IBAction)didPressReadArticleButton:(id)sender;
- (IBAction)didPressNextQuestionButton:(id)sender;

@end

@implementation WTGameAnswerPage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.scoreView.layer.cornerRadius = CGRectGetWidth(self.scoreView.frame)/2;
}


- (void)setupWithNewsItem:(WTNewsItem *)item andTotalScore:(NSInteger)totalScore
{
    self.titleLabel.text = [item.headlines objectAtIndex:item.correctAnswerIndex];
    self.contentLabel.text = item.standFirst;
    
    self.imageView.image = [[WTUtil wtCache] objectForKey:item.imageUrl];
    
    // score view
    if (item.score > 0) {
        self.scoreLabel1.text = @"THAT'S RIGHT!";
        self.scoreView.backgroundColor = [UIColor blueColor];
    } else {
        self.scoreLabel1.text = @"TIME EXPIRED!";
        self.scoreView.backgroundColor = [UIColor redColor];
    }
    
    // attribute label text
    NSString *label2Text = [NSString stringWithFormat:@"+%ld POINTS", (long)item.score];
    [self.scoreLabel2 setAttributedText:[WTUtil attributedText:label2Text withRange:NSMakeRange(1, 2) withRegularFontSize:17 withBoldFontSize:24]];
    
    NSString *label3Text = [NSString stringWithFormat:@"%ld   TOTAL", totalScore];
    [self.scoreLabel3 setAttributedText:[WTUtil attributedText:label3Text withRange:NSMakeRange(0, 3) withRegularFontSize:17 withBoldFontSize:24]];
    
    // animate score view
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"transform"];
    ba.autoreverses = YES;
    ba.duration = 0.6;
    ba.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.5, .5, 1)];
    [self.scoreView.layer addAnimation:ba forKey:nil];
}


#pragma mark - actions

- (void)didPressNextQuestionButton:(id)sender
{
    [self.delegate handleNextQuestion];
}

- (void)didPressReadArticleButton:(id)sender
{
    [self.delegate handleReadArticle];
}

@end
